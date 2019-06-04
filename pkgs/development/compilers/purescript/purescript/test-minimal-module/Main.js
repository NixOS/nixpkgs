"use strict"

exports.log = function (s) {
    return function () {
        console.log(s);
        return {};
    };
};
