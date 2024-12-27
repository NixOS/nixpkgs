import os
import sys

from playwright.sync_api import sync_playwright

with sync_playwright() as p:
    browser = p.chromium.launch()
    context = browser.new_context()
with open(os.environ["out"], "w") as f:
    f.write("OK")
