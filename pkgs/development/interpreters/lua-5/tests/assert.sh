# Always failing assertion with a message.
#
# Example:
#     fail "It should have been but it wasn't to be"
function fail() {
    echo "$1"
    exit 1
}


function assertStringEqual {

    if ! diff <(echo "$1") <(echo "$2") ; then
        fail "Strings differ"
    fi
}
