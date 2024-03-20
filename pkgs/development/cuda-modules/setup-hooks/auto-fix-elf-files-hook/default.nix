# Helper hook used in both autoAddCudaCompatRunpath and
# autoAddDriverRunpath that applies a generic patching action to all elf
# files with a dynamic linking section.
{ makeSetupHook }: makeSetupHook { name = "auto-fix-elf-files-hook"; } ./auto-fix-elf-files-hook.sh
