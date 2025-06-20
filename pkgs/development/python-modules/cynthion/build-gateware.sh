echo "Sourcing build-gateware-hook"

_buildGatewareHook() {
    echo "Building gateware"
    # find site-packages
    echo "site_packages" "$out/@pythonSitePackages@"

    # generate the list of platforms
    local -a luna_platforms
    mapfile -t luna_platforms < <(python <<EOS
import inspect
import cynthion.gateware.platform
for name, obj in inspect.getmembers(cynthion.gateware.platform):
    if inspect.isclass(obj):
        print(name)
EOS
)
    echo "building for platforms" "${luna_platforms[@]}"

    # run the builds in parallel
    local -a bitstreams pids
    bitstreams=(analyzer facedancer selftest)
    pids=()

    local N i j k
    local platform bitstream platform_folder bitstream_out_path job_pid
    N=${enableParallelBuilding:+${NIX_BUILD_CORES}}
    N=${N:-1}
    echo "Running ${N} parallel builds ${enableParallelBuilding} ${NIX_BUILD_CORES}"
    for i in "${!luna_platforms[@]}"; do
        platform="${luna_platforms[i]}"
        platform_folder="$out/@pythonSitePackages@/cynthion/assets/${luna_platforms[i]}"
        mkdir -p "$platform_folder"
        for j in "${!bitstreams[@]}"; do
            k=$((i*${#bitstreams[@]}+j))
            bitstream="${bitstreams[j]}"

            export LUNA_PLATFORM="cynthion.gateware.platform:${platform}"
            out_path="${platform_folder}/${bitstream}.bit"
            python -m cynthion.gateware.${bitstream}.top --output "${out_path}" &
            job_pid=$!
            pids+=($job_pid)

            echo Build $k is for: $platform/$bitstream with PID $job_pid

            if [[ $(( (k+1)%N )) == 0 ]]; then
                for pid in "${pids[@]}"; do
                    echo "Waiting for PID $pid"
                    wait $pid || exit 1
                done
                pids=()
            fi
        done
    done

    for pid in "${pids[@]}"; do
        echo "Waiting for PID $pid"
        wait $pid || exit 1
    done
}

postInstallHooks+=(_buildGatewareHook)
