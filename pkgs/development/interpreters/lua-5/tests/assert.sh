# Always failing assertion with a message.
#
# Example:
#     fail "It should have been but it wasn't to be"
function fail() {
    echo "$1"
    exit 1
}


function assertStringEqual() {
    if ! diff <(echo "$1") <(echo "$2") ; then
        fail "expected \"$1\" to be equal to \"$2\""
    fi
}

function assertStringContains() {
    if ! echo "$1" | grep -q "$2" ; then
        fail "expected \"$1\" to contain \"$2\""
    fi
}
