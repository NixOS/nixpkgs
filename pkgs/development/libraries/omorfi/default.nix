{ lib
, stdenv
, autoreconfHook
, cg3
, fetchFromGitHub
, hfst
, hfst-ospell
, icu
, libvoikko
, makeWrapper
, pkg-config
, python3
, zip
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "omorfi";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner = "flammie";
    repo = "omorfi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-UoqdwNWCNOPX6u1YBlnXUcB/fmcvcy/HXbYciVrMBOY=";
  };

  # Fix for omorfi-hyphenate.sh file not found error
  postInstall = ''
    ln -s $out/share/omorfi/{omorfi.hyphenate-rules.hfst,omorfi.hyphenate.hfst}
  '';

  nativeBuildInputs = [
    autoreconfHook
    cg3
    makeWrapper
    pkg-config
    python3
    zip
    python3.pkgs.wrapPython
  ];

  buildInputs = [
    python3.pkgs.hfst
    hfst-ospell
    libvoikko
  ];

  # Supplied pkg-config file doesn't properly expose these
  propagatedBuildInputs = [
    hfst
    icu
  ];

  # Wrap shell scripts so they find the Python scripts
  # omorfi.bash inexplicably fails when wrapped
  preFixup = ''
    wrapPythonProgramsIn "$out/bin" "$out ${python3.pkgs.hfst}"
    for i in "$out/bin"/*.{sh,bash}; do
      if [ $(basename "$i") != "omorfi.bash" ]; then
        wrapProgram "$i" --prefix "PATH" : "$out/bin/"
      fi
    done
  '';

  # Enable all features
  configureFlags = [
    "--enable-labeled-segments"
    "--enable-lemmatiser"
    "--enable-segmenter"
    "--enable-hyphenator"
  ];

  meta = with lib; {
    description = "Analysis for Finnish text";
    homepage = "https://github.com/flammie/omorfi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ lurkki ];
    # Darwin build fails due to hfst not being found
    broken = stdenv.isDarwin;
  };
})
