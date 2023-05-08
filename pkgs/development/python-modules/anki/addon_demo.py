# Copyright: Ankitects Pty Ltd and contributors
# License: GNU AGPL, version 3 or later; http://www.gnu.org/licenses/agpl.html

# This file was modified by Paul Hervot (not affiliated with Ankitects) on may
# 8th 2023 to make it pass a mypy check with the intent of using it as a test
# case for the nixpkgs packaging of aqt, it isn't functional beyond that.
# Original from https://github.com/ankitects/anki-addons/blob/main/demos/card_did_render/__init__.py

"""
An example of how you can transform the rendered card content in Anki 2.1.20.
"""

from typing import Tuple

# explicit collection import to avoid a circular dependency when importing hooks
import anki.collection

from anki import hooks
from anki.template import TemplateRenderContext, TemplateRenderOutput


def on_card_did_render(output: TemplateRenderOutput, context: TemplateRenderContext):
    # let's uppercase the characters of the front text
    output.question_text = output.question_text.upper()

    # if the note is tagged "easy", show the answer in green
    # otherwise, in red
    if context.note().has_tag("easy"):
        colour = "green"
    else:
        colour = "red"

    output.answer_text += f"<style>.card {{ color: {colour}; }}</style>"


# register our function to be called when the hook fires
hooks.card_did_render.append(on_card_did_render)
