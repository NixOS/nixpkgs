# shellcheck shell=bash

udevCheckHook() {
    runHook preUdevCheck
    echo Executing udevCheckPhase

    # as per nixos/modules/services/hardware/udev.nix:
    # - both /lib and /etc is valid paths for udev rules
    # - udev rules are expected to be part of the $bin output
    # However, not all udev rules are actually in $bin (some are in $lib or $out).
    # This means we have to actually check all outputs here.
    for output in $(getAllOutputNames); do
        for path in etc lib ; do
            if [ -d "${!output}/$path/udev/rules.d" ]; then
                @udevadm@ verify --resolve-names=late --no-style "${!output}/$path/udev/rules.d"
            fi
        done
    done

    runHook postUdevCheck
    echo Finished udevCheckPhase
}

if [[ -z "${dontUdevCheck-}" && -n "@udevadm@" ]]; then
    echo "Using udevCheckHook"
    preInstallCheckHooks+=(udevCheckHook)
fi
