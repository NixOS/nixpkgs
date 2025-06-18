# -*- coding: utf-8 -*-
import re
from xkeysnail.transform import *

aa = False
def aaset(v):
    def _aaset():
        transform._mark_set = False
        global aa; aa = v
    return _aaset
def aaif():
    def _aaif():
        global aa; transform._mark_set = False
        if aa: aa = False; return K("esc")
        return K("enter")
    return _aaif
def aaflip():
    def _aaflip():
        transform._mark_set = not transform._mark_set;
    return _aaflip

define_keymap(re.compile("Google-chrome|Chromium-browser|firefox"), {
    K("C-b"): with_mark(K("left")),
    K("C-f"): with_mark(K("right")),
    K("C-p"): with_mark(K("up")),
    K("C-n"): with_mark(K("down")),
    K("M-b"): with_mark(K("C-left")),
    K("M-f"): with_mark(K("C-right")),
    K("C-a"): with_mark(K("home")),
    K("C-e"): with_mark(K("end")),

    K("C-w"): [K("C-x"), set_mark(False)],
    K("M-w"): [K("C-c"), K("right"), set_mark(False)],
    K("C-y"): [K("C-v"), set_mark(False)],
    K("C-k"): [K("Shift-end"), K("C-x"), set_mark(False)],
    K("C-d"): [K("delete"), set_mark(False)],
    K("M-d"): [K("C-delete"), set_mark(False)],
    K("M-backspace"): [K("C-backspace"), set_mark(False)],
    K("C-slash"): [K("C-z"), set_mark(False)],

    K("C-space"): aaflip(),
    K("C-M-space"): with_or_set_mark(K("C-right")),

    K("enter"): aaif(),
    K("C-s"): [K("F3"), aaset(True)],
    K("C-r"): [K("Shift-F3"), aaset(True)],
    K("C-g"): [K("esc"), aaset(False)]
})
