#!/bin/sh
# This is based on the script by David T. Lewis posted here:
#  http://lists.squeakfoundation.org/pipermail/vm-dev/2017-April/024836.html
#
# VM run utility script
# usage: run <myimage>
#
# Select a VM and run an image based on the image format number

PATH=$PATH:@file@/bin

# Search for the image filename in the command line arguments
for arg in $* $SQUEAK_IMAGE; do
    case ${arg} in
        -*) # ignore
        ;;
        *) # either an option argument or the image name
            if test -e ${arg}; then
                magic=$(file -L -b -m @magic@ "$arg")
                case "$magic" in
                    "Smalltalk image V3 32b"*)
                        image=${arg}
                        vm=@cog32@/bin/pharo-cog
                        ;;
                    "Smalltalk image Spur 32b"*)
                        image=${arg}
                        vm=@spur32@/bin/pharo-spur
                        ;;
                    "Smalltalk image Spur 64b"*)
                        if [ "@spur64vm@" == "none" ]; then
                            echo "error: detected 64-bit image but 64-bit VM is not available" >&2
                            exit 1
                        fi
                        image=${arg}
                        vm=@spur64@/bin/pharo-spur64
                        ;;
                esac
            fi
            ;;
    esac
done

# Print a message to explain our DWIM'ery.
if [ -n "$image" ]; then
    echo "using VM selected by image type."
    echo "  image: $image"
    echo "  type:  $magic"
    echo "  vm:    $vm"
else
    echo "using default vm; image type not detected"
    vm=@cog32@/bin/pharo-cog
fi

# Run the VM
set -f
exec -- "${vm}" "$@"

