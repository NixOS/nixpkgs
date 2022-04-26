import csv
import re
from collections import defaultdict

# fc-scan ./hinted ./unhinted -f '"%{fullname[0]}","%{file}"\n' > scan.csv

blacklist = [
  # provides "Noto S Display, M" while main font provides "Noto S, Display M".
  # package both by blacklisting and force-adding Display fonts later
  # https://github.com/googlefonts/noto-fonts/issues/2315
  r"\./unhinted/(slim-)?variable-ttf/NotoSansDisplay-Italic-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansDisplay-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSerifDisplay-VF\.ttf",
  # provides "Noto Sans Display X, Regular" instead of "Noto Sans Display, X"
  # https://github.com/googlefonts/noto-fonts/issues/2315
  r"\./unhinted/otf/NotoSansDisplay/NotoSansDisplay-[A-Za-z]+\.otf",
  # provides "Noto Sans X" instead of "Noto Sans X UI"
  # https://github.com/googlefonts/noto-fonts/issues/2316
  r"\./unhinted/(slim-)?variable-ttf/NotoSansKannadaUI-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansMalayalamUI-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansSinhalaUI-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansTamilUI-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansTeluguUI-VF\.ttf",
  # extraneous files
  # comment in https://github.com/googlefonts/noto-fonts/issues/2316
  r"\./unhinted/(slim-)?variable-ttf/NotoSansTamil-android-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansTamilUI-android-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSansTamilUI-VF-torecover\.ttf",
  # provides "FontName" instead of "Font Name"
  # https://github.com/googlefonts/noto-fonts/issues/2317
  r"\./unhinted/(slim-)?variable-ttf/NotoSansMeeteiMayek-VF\.ttf",
  r"\./unhinted/(slim-)?variable-ttf/NotoSerifTamilSlanted-VF\.ttf",
  # font names are missing Bold, Italic, etc.
  # https://github.com/googlefonts/noto-fonts/issues/2317
  r"\./unhinted/(slim-)?variable-ttf/NotoSansHanifiRohingya-VF\.ttf",
  # duplicate fonts in NotoSansTifinagh
  # https://github.com/googlefonts/noto-fonts/issues/2326
  r"\./unhinted/otf/NotoSansTifinagh/NotoSansTifinagh[A-Z].*\.otf",
  # croscore fonts, packaged separately
  r"\./unhinted/otf/Arimo/.*",
  r"\./unhinted/otf/Cousine/.*",
  r"\./unhinted/otf/Tinos/.*"
]

blacklist = list(map(re.compile, blacklist))

class Font:
  def __init__(self):
    self.hinted_ttf = None
    self.unhinted_ttf = None
    self.otf = None
    self.vf = None
    self.slimvf = None
    self.extra = None

fonts = defaultdict(Font)

# KDE uses Light/LightItalic, so keep those in the main package, see
# https://mail.kde.org/pipermail/distributions/2017-November/000706.html
# https://mail.kde.org/pipermail/distributions/2017-November/000709.html
extrafontpattern = re.compile(r".*(Black|Condensed|Extra|Medium|Semi|Thin).*")

with open('scan.csv', newline='') as csvfile:
  scanreader = csv.reader(csvfile, delimiter=',', quotechar='"')
  for row in scanreader:
    [font, fontfile] = row
    if any(rgx.match(fontfile) for rgx in blacklist):
      continue
    if fontfile.startswith("./hinted/ttf"):
      if fonts[font].hinted_ttf and fonts[font].hinted_ttf != fontfile:
        print("duplicate httf", font, ":", fonts[font].hinted_ttf, "and", fontfile)
      fonts[font].hinted_ttf = fontfile
    elif fontfile.startswith("./unhinted/ttf"):
      if fonts[font].unhinted_ttf and fonts[font].unhinted_ttf != fontfile:
        print("duplicate uttf", font, ":", fonts[font].unhinted_ttf, "and", fontfile)
      fonts[font].unhinted_ttf = fontfile
    elif fontfile.startswith("./unhinted/otf"):
      if fonts[font].otf and fonts[font].otf != fontfile:
        print("duplicate otf", font, ":", fonts[font].otf, "and", fontfile)
      fonts[font].otf = fontfile
    elif fontfile.startswith("./unhinted/variable-ttf"):
      if fonts[font].vf and fonts[font].vf != fontfile and font != "":
        print("duplicate vf", font, ":", fonts[font].vf, "and", fontfile)
      fonts[font].vf = fontfile
    elif fontfile.startswith("./unhinted/slim-variable-ttf"):
      if fonts[font].slimvf and fonts[font].slimvf != fontfile and font != "":
        print("duplicate slim", font, ":", fonts[font].slimvf, "and", fontfile)
      fonts[font].slimvf = fontfile
    else:
      print("Unknown font directory: ", ', '.join(row))
      raise NotImplementedError

    fonts[font].extra = extrafontpattern.match(font) != None or font == ""

# inconsistent names, see https://github.com/googlefonts/noto-fonts/issues/2317
# for these names the VF names seem acceptable
lightlightpattern = re.compile(r"Noto Sans Hebrew (New )?Light Light")
hmongpattern = re.compile(r"Noto Serif Nyiakeng Puachue Hmong .+")

# compute noto-font files

mode = "vf" # "otf" "slimvf" "vf"
modeextra = "vf" # "otf" "vf"

# force-add Display VF's to file list, see above
# https://github.com/googlefonts/noto-fonts/issues/2315
filelist = set(
  ["./unhinted/variable-ttf/NotoSansDisplay-Italic-VF.ttf",
  "./unhinted/variable-ttf/NotoSansDisplay-VF.ttf",
  "./unhinted/variable-ttf/NotoSerifDisplay-VF.ttf"])

for name, font in fonts.items():
  if font.extra:
    continue

  if font.vf and mode == "vf":
    if not font.otf and name != "" and not lightlightpattern.match(name) and not hmongpattern.match(name):
      print("missing otf:", name, ", ", font.vf)
      continue
    filelist.add(font.vf)
  elif font.slimvf and mode == "slimvf":
    if not font.otf and font.slimvf != "":
      print("missing otf:", name, ", ", font.slimvf)
      continue
    filelist.add(font.slimvf)
  elif font.otf:
    filelist.add(font.otf)
  elif font.vf:
    continue
  else:
    print("weird font: ", name, ", ", font)
    raise NotImplementedError

with open('noto_fonts_list.txt', 'w') as f:
    for item in filelist:
        f.write("%s\n" % item)

extra_list = set()

for name, font in fonts.items():
  if font.vf in filelist or font.slimvf in filelist or font.otf in filelist:
    continue

  if font.vf and modeextra != "otf":
    if not font.otf and name != "" and not lightlightpattern.match(name) and not hmongpattern.match(name):
      print("missing otf:", name, ", ", font.vf)
      continue
    extra_list.add(font.vf)
  elif font.otf:
    extra_list.add(font.otf)
  elif font.vf:
    continue
  else:
    print("weird font: ", name, ", ", font)
    raise NotImplementedError

with open('noto_extra_list.txt', 'w') as f:
    for item in extra_list:
        f.write("%s\n" % item)

