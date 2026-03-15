#!@shell@
set -euo pipefail

declare -a final_args=()

WORK_DIR=$(mktemp -d /tmp/flang_wrapper.XXXXXX)
cleanup() { rm -rf "$WORK_DIR"; }
trap cleanup EXIT

emit() {
  local mode="$1"
  local val="$2"
  local target_rsp="$3"

  if [[ "$mode" == "CLI" ]]; then
    final_args+=("$val")
  else
    printf '%s\n' "$val" >> "$target_rsp"
  fi
}

process_stream() {
  local mode="$1"; shift
  local current_rsp="$1"; shift

  while (($# > 0)); do
    local arg="$1"

    if [[ "$arg" == "-nostdlibinc" ]] || \
       [[ "$arg" == -frandom-seed=* ]] || \
       [[ "$arg" == -fmacro-prefix-map=* ]] || \
       [[ "$arg" == "-mno-omit-leaf-frame-pointer" ]] || \
       [[ "$arg" == "-Werror=unguarded-availability" ]]; then
      shift
      continue
    fi

    if [[ "$arg" == "-isystem" ]] || [[ "$arg" == "-idirafter" ]]; then
      emit "$mode" "-I" "$current_rsp"
      shift
      if (($# > 0)); then
        emit "$mode" "$1" "$current_rsp"
        shift
      fi
      continue
    fi

    emit "$mode" "$arg" "$current_rsp"
    shift
  done
}

for arg in "$@"; do
  if [[ "$arg" == @* ]]; then
    CURRENT_RSP=$(mktemp "$WORK_DIR/rsp.XXXXXX")

    declare -a file_content=()
    while IFS= read -r line || [ -n "$line" ]; do
      file_content+=("$line")
    done < "${arg:1}"

    process_stream "FILE" "$CURRENT_RSP" "${file_content[@]}"
    final_args+=("@$CURRENT_RSP")
  else
    process_stream "CLI" "" "$arg"
  fi
done

exec -a "$0" "@flang_unwrapped@/bin/flang-new" "${final_args[@]}"
