{
  lib,
  python3Packages,
  fetchFromGitHub,
  wrapGAppsHook3,
  p7zip,
  parted,
  grub2,
}:

<<<<<<< HEAD
python3Packages.buildPythonApplication rec {
  pname = "woeusb-ng";
  version = "0.2.12";
  pyproject = true;
=======
with python3Packages;

buildPythonApplication rec {
  pname = "woeusb-ng";
  version = "0.2.12";
  format = "setuptools";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "WoeUSB";
    repo = "WoeUSB-ng";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-2opSiXbbk0zDRt6WqMh97iAt6/KhwNDopOas+OZn6TU=";
  };

  build-system = [ python3Packages.setuptools ];

=======
    rev = "v${version}";
    hash = "sha256-2opSiXbbk0zDRt6WqMh97iAt6/KhwNDopOas+OZn6TU=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postPatch = ''
    substituteInPlace setup.py WoeUSB/utils.py \
      --replace-fail "/usr/local/" "$out/" \
      --replace-fail "/usr/" "$out/"
    substituteInPlace miscellaneous/WoeUSB-ng.desktop \
      --replace-fail "/usr/" "$out/" \
  '';

  nativeBuildInputs = [
    wrapGAppsHook3
  ];
  dontWrapGApps = true;
  preFixup = ''
<<<<<<< HEAD
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : "${
        lib.makeBinPath [
          p7zip
          parted
          grub2
        ]
      }"
    )
  '';

  dependencies = [
    python3Packages.termcolor
    python3Packages.wxpython
    python3Packages.six
=======
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  propagatedBuildInputs = [
    p7zip
    parted
    grub2
    termcolor
    wxpython
    six
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  preConfigure = ''
    mkdir -p $out/bin $out/share/applications $out/share/polkit-1/actions
  '';

  # Unable to access the X Display, is $DISPLAY set properly?
  doCheck = false;

  meta = {
    description = "Tool to create a Windows USB stick installer from a real Windows DVD or image";
    homepage = "https://github.com/WoeUSB/WoeUSB-ng";
    mainProgram = "woeusb";
    license = lib.licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = [ lib.maintainers.stunkymonkey ];
=======
    maintainers = with lib.maintainers; [ stunkymonkey ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    platforms = lib.platforms.linux;
  };
}
