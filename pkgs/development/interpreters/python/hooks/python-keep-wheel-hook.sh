# Setup hook for pip.
echo "Sourcing pythonKeepWheelHook"

pythonKeepWheelHook() {
    echo "Executing pythonKeepWheelHook"

    local target
    target=${wheel:-$out/wheel}

    mkdir -p $target
    cp dist/*.whl $target/

    echo "Finished executing pythonKeepWheelHook"
}

echo "Using pythonKeepWheelHook"
postFixupHooks+=('pythonKeepWheelHook')
