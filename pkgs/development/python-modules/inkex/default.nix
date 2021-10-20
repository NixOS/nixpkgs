{ buildPythonPackage
, inkscape
, lxml
, python
}:

buildPythonPackage {
  pname = "inkex";
  inherit (inkscape) version;

  format = "other";

  propagatedBuildInputs = [
    lxml
  ];

  # We just copy the files.
  dontUnpack = true;
  dontBuild = true;

  # No tests installed.
  doCheck = false;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/${python.sitePackages}"
    cp -r "${inkscape}/share/inkscape/extensions/inkex" "$out/${python.sitePackages}"

    runHook postInstall
  '';

  meta = inkscape.meta // {
    description = "Inkscape Extensions Library";
    longDescription = ''
      This module provides support for inkscape extensions, it includes support for opening svg files and processing them.

      Standalone, it is especially useful for running tests for Inkscape extensions.
    '';
  };
}
