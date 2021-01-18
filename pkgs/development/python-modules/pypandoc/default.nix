{ lib, stdenv, buildPythonPackage, fetchFromGitHub, fetchpatch
, pandoc, haskellPackages, texlive }:

buildPythonPackage rec {
  pname = "pypandoc";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "bebraw";
    repo = pname;
    rev = version;
    sha256 = "1lpslfns6zxx7b0xr13bzg921lwrj5am8za0b2dviywk6iiib0ld";
  };

  # https://github.com/bebraw/pypandoc/pull/204
  patches = [
    (fetchpatch {
      url = "https://github.com/sternenseemann/pypandoc/commit/e422e277dd667c77dae11fad931dbb6015e9a784.patch";
      sha256 = "11l11kh2a4k0h1g4yvijb60076kzxlkrvda3x6dc1s8fz352bpg3";
    })
  ];

  postPatch = ''
    # set pandoc path statically
    sed -i '/^__pandoc_path = None$/c__pandoc_path = "${pandoc}/bin/pandoc"' pypandoc/__init__.py

    # Skip test that requires network access
    sed -i '/test_basic_conversion_from_http_url/i\\    @unittest.skip\("no network access during checkPhase"\)' tests.py
  '';

  preCheck = ''
    export PATH="${haskellPackages.pandoc-citeproc}/bin:${texlive.combined.scheme-small}/bin:$PATH"
  '';

  meta = with lib; {
    description = "Thin wrapper for pandoc";
    homepage = "https://github.com/bebraw/pypandoc";
    license = licenses.mit;
    maintainers = with maintainers; [ sternenseemann bennofs ];
  };
}
