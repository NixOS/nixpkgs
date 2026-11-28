#!/usr/bin/env bash

# Helper script to dynamically update NetworkManager DNS via nmcli.
# Replaces upstream's chattr /etc/resolv.conf hack with clean runtime overrides.

set -eo pipefail

SCRIPT_NAME="${BASH_SOURCE[0]##*/}"
STATE_DIR="/var/lib/windscribe"
DEV_NAME="${dev:-${DEV:-tun0}}"
STATE_FILE="${STATE_DIR}/nm-dns-${DEV_NAME}.state"

log() {
  logger -t "$SCRIPT_NAME" "$@"
}

# Collect active, non-virtual devices currently managed by NetworkManager
get_active_devices() {
  nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null | awk -F: '
    $3 == "connected" && $2 != "loopback" && $2 != "tun" && $2 != "tap" && $2 != "wireguard" {
      print $1
    }
  '
}

up() {
  local -a dns_v4=()
  local -a dns_v6=()
  local -a domains=()

  # Parse OpenVPN foreign_option_* environment variables
  for opt_var in "${!foreign_option_@}"; do
    local opt="${!opt_var}"
    case "$opt" in
      "dhcp-option DNS "*)
        local ip="${opt#dhcp-option DNS }"
        if [[ "$ip" =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
          dns_v4+=("$ip")
        fi
        ;;
      "dhcp-option DNS6 "*)
        local ip="${opt#dhcp-option DNS6 }"
        dns_v6+=("$ip")
        ;;
      "dhcp-option DOMAIN "*|"dhcp-option DOMAIN-SEARCH "*)
        local dom="${opt#* }"
        dom="${dom#* }"
        domains+=("$dom")
        ;;
    esac
  done

  # Exit cleanly if no DNS options were pushed
  if (( ${#dns_v4[@]} == 0 && ${#dns_v6[@]} == 0 )); then
    log "No DNS servers pushed; nothing to configure."
    return 0
  fi

  local -a active_devs=()
  mapfile -t active_devs < <(get_active_devices)

  if (( ${#active_devs[@]} == 0 )); then
    log "No active physical NetworkManager devices found."
    return 0
  fi

  # Build nmcli runtime override parameters
  local -a nmcli_args=()

  if (( ${#dns_v4[@]} > 0 )); then
    local v4_str="${dns_v4[*]}"
    nmcli_args+=(ipv4.dns "${v4_str// /,}" ipv4.ignore-auto-dns yes ipv4.dns-priority -50)
  fi

  if (( ${#dns_v6[@]} > 0 )); then
    local v6_str="${dns_v6[*]}"
    nmcli_args+=(ipv6.dns "${v6_str// /,}" ipv6.ignore-auto-dns yes ipv6.dns-priority -50)
  else
    # Prevent IPv6 DNS leaks through local gateway while VPN is active
    nmcli_args+=(ipv6.ignore-auto-dns yes)
  fi

  if (( ${#domains[@]} > 0 )); then
    local dom_str="${domains[*]}"
    nmcli_args+=(ipv4.dns-search "${dom_str// /,}")
  fi

  mkdir -p "$STATE_DIR" 2>/dev/null || true
  : > "$STATE_FILE"

  for target in "${active_devs[@]}"; do
    log "Applying VPN DNS to '$target': ${dns_v4[*]} ${dns_v6[*]}"
    if nmcli device modify "$target" "${nmcli_args[@]}"; then
      echo "$target" >> "$STATE_FILE"
    else
      log "Failed to apply runtime DNS to '$target'"
    fi
  done
}

down() {
  if [[ -f "$STATE_FILE" ]]; then
    while read -r target; do
      [[ -n "$target" ]] || continue
      log "Restoring original NetworkManager DNS for '$target'"
      # Reset runtime modifications back to the active connection profile
      nmcli device reapply "$target" 2>/dev/null || {
        # Fallback if reapply fails: clear manual DNS overrides explicitly
        nmcli device modify "$target" ipv4.dns "" ipv4.ignore-auto-dns no ipv6.ignore-auto-dns no 2>/dev/null || true
      }
    done < "$STATE_FILE"
    rm -f "$STATE_FILE"
  else
    # Fallback if state file was purged: reapply all active devices
    for target in $(get_active_devices); do
      nmcli device reapply "$target" 2>/dev/null || true
    done
  fi
}

action="${1:-${script_type:-down}}"

case "$action" in
  up)   up ;;
  down) down ;;
  *)    log "Unknown action: '$action'" ; exit 1 ;;
esac
