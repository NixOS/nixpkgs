{
  stdenv,
  lib,
  fetchFromGitHub,
  wmctrl,
  python3Packages,
  buildPythonPackage,
  pytest,
  mock,
  babel,
  pyqt5,
  xlib,
  pyserial,
  appdirs,
  wcwidth,
  setuptools,
  rtf-tokenize,
  plover-stroke,
  wrapQtAppsHook,
}:
let
  plover = python3Packages.buildPythonPackage rec {
    pname = "plover";
    version = "4.0.0rc2";
    pyproject = true;
    build-system = [ setuptools ];

    meta = with lib; {
      broken = stdenv.hostPlatform.isDarwin;
      description = "OpenSteno Plover stenography software";
      maintainers = with maintainers; [
        twey
        kovirobi
      ];
      license = licenses.gpl2;
    };

    src = fetchFromGitHub {
      owner = "openstenoproject";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-rmMec/BbvOJ92u8Tmp3Kv2YezzJxB/L8UrDntTDSKj4=";
    };

    # I'm not sure why we don't find PyQt5 here but there's a similar
    # sed on many of the platforms Plover builds for
    postPatch = "sed -i /PyQt5/d setup.cfg";

    nativeCheckInputs = [
      pytest
      mock
    ];
    nativeBuildInputs = [ wrapQtAppsHook ];
    propagatedBuildInputs = [
      babel
      pyqt5
      xlib
      pyserial
      appdirs
      wcwidth
      setuptools
      rtf-tokenize
      plover-stroke
    ];

    preFixup = ''
      makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    '';
  };

  plugins = lib.attrsets.mapAttrs' (name: value: {
    name = builtins.substring 7 (builtins.stringLength name) name;
    inherit value;
  }) (lib.attrsets.filterAttrs (k: v: lib.strings.hasPrefix "plover-" k) python3Packages);
in
plover
// {
  inherit plugins;
  withPlugins = ps: python3Packages.python.withPackages (_: ps plugins);
}
