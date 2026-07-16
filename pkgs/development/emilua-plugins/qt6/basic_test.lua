local qt = require 'qt6'
local qml = qt.load_qml(byte_span.append([[
    import QtQml 2.0
    QtObject {
        function foobar(a: int, b: int): int {
            return a + b
        }
    }
]]))
assert(qml.object('foobar(int,int)', 1, 2), 3)

print("done 👍")
