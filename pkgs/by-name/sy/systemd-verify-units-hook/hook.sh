#! @shell@

# shellcheck shell=bash

systemdVerifyUnitsHook() {
    runHook preSystemdVerifyUnits
    echo "Executing systemdVerifyUnitsPhase"

    declare -a unitsToCheck
    readarray -d '' -t unitsToCheck < <(
      shopt -s nullglob

      if [[ -z "${systemdVerifySkipDefaultPaths-}" ]]; then
          declare output
          for output in $(getAllOutputNames); do
              declare unit
              for unit in "${!output}"/{etc,lib}/systemd/system/*.{service,socket,device,mount,automount,swap,target,path,timer,snapshot,slice,scope}; do
                  printf "%s\0" "$unit"
              done
              declare override
              for override in "${!output}"/{etc,lib}/systemd/system/*.{service,socket,device,mount,automount,swap,target,path,timer,snapshot,slice,scope}.d/*; do
                  printf "%s\0" "$override"
              done
          done
      fi

      if [[ -n "${systemdVerifyExtraUnits-}" ]]; then
          declare globPattern
          for globPattern in $systemdVerifyExtraUnits; do
              declare expanded
              for expanded in $globPattern; do
                  if [[ -f "$expanded" ]]; then
                      printf "%s\0" "$expanded"
                      continue
                  fi
              done
          done
      fi
    )

    declare -a skipPatterns=()
    if [[ -n "${systemdVerifySkipUnits-}" ]]; then
        declare skipPattern
        for skipPattern in $systemdVerifySkipUnits; do
            skipPatterns+=("$skipPattern")
        done
    fi

    declare -a filteredUnits=()
    declare -A seen=()
    declare unit
    for unit in "${unitsToCheck[@]}"; do
        declare skipUnit=false
        declare skipPattern
        for skipPattern in "${skipPatterns[@]}"; do
            if [[ "$unit" == *"$skipPattern"* || "$(basename "$unit")" == "$skipPattern" ]]; then
                skipUnit=true
                break
            fi
        done
        if [[ $skipUnit == true ]]; then
            printf "Skipping systemd unit: %s\n" "$unit"
        else
            if [[ -z "${seen[$unit]-}" ]]; then
                seen[$unit]=1
                filteredUnits+=("$unit")
            fi
        fi
    done

    # See ../../sw/switch-to-configuration-ng/src/src/main.rs
    declare -a defaultAllowedUnknownKeys=(
      'X-NotSocketActivated'
      'X-OnlyManualStart'
      'X-Reload-Triggers'
      'X-ReloadIfChanged'
      'X-Restart-Triggers'
      'X-RestartIfChanged'
      'X-StopIfChanged'
      'X-StopOnConfiguration'
      'X-StopOnReconfiguration'
      'X-StopOnRemoval'
    )

    declare -A allowedUnknownKeys=()
    if [[ -z "${systemdVerifyDisableDefaultUnknownKeys-}" ]]; then
        declare defaultKey
        for defaultKey in "${defaultAllowedUnknownKeys[@]}"; do
            allowedUnknownKeys["$defaultKey"]=1
        done
    fi

    if [[ -n "${systemdVerifyAllowUnknownKeys-}" ]]; then
        declare key
        for key in $systemdVerifyAllowUnknownKeys; do
            allowedUnknownKeys["$key"]=1
        done
    fi

    declare -A allowedUnknownSections=()
    if [[ -n "${systemdVerifyAllowUnknownSections-}" ]]; then
        declare section
        for section in $systemdVerifyAllowUnknownSections; do
            allowedUnknownSections["$section"]=1
        done
    fi

    if [[ ${#filteredUnits[@]} -gt 0 ]]; then
        declare unit
        for unit in "${filteredUnits[@]}"; do
            printf "Verifying systemd unit: %s\n" "$unit"

            # NOTE: systemd-analyze needs /run/systemd; bubblewrap is used to provide a fake environment.
            declare -a bwrapFlags=(
                --dev /dev
                --bind "/nix" "/nix"
                --tmpfs "$HOME"
                --tmpfs /tmp
                --bind /bin /bin
                --bind /tmp /run/systemd
                --bind "$unit" "$unit"
            )
            declare output
            for output in $(getAllOutputNames); do
                bwrapFlags+=(--bind "${!output}" "${!output}")
            done

            #TODO: test manpages too
            set +e
            declare systemdAnalayzeStderr="$('@bwrap@' "${bwrapFlags[@]}" '@systemdanalyze@' verify --man=no --recursive-errors=no "$unit" 2>&1 1>/dev/null)"
            declare exitCode="$?"
            set -e

            declare isError=false
            declare line
            while IFS= read -r line; do
                if [[ $line =~ ^.*Unknown\ key\ \'([^\']+)\'\ in\ section\ \[([^\]]+)\],\ ignoring\.?$ ]]; then
                    declare keyname="${BASH_REMATCH[1]}"
                    declare sectionname="${BASH_REMATCH[2]}"
                    if [[ -n "${allowedUnknownKeys[$keyname]-}" || -n "${allowedUnknownSections[$sectionname]-}" ]]; then
                        continue
                    fi
                fi

                if [[ $line =~ ^.*Unknown\ section\ \'([^\']+)\'\.\ Ignoring\.$ ]]; then
                    declare sectionname="${BASH_REMATCH[1]}"
                    if [[ -n "${allowedUnknownSections[$sectionname]-}" ]]; then
                        continue
                    fi
                fi

                if [[ -n "$line" ]]; then
                    printf '%s\n' "$line" >&2
                    isError=true
                fi
            done <<< "$systemdAnalayzeStderr"

            if [[ $isError == true ]]; then
                printf "systemd-analyze verify failed for unit: %s\n" "$unit" >&2
                if [[ "$exitCode" -eq 0 ]]; then
                    exitCode=1
                fi
                exit "$exitCode"
            fi
        done
    else
        echo "No systemd units to verify"
    fi

    runHook postSystemdVerifyUnits
    echo "Finished systemdVerifyUnitsPhase"
}

if [[ -z "${dontSystemdVerifyUnits-}" && -n '@systemdanalyze@' ]]; then
    echo "Using systemdVerifyUnitsHook"
    preInstallCheckHooks+=(systemdVerifyUnitsHook)
fi
