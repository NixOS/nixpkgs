{ lib
, buildPythonPackage
, fetchFromGitHub
, stdenv
, zlib
, xz
, ncompress
, gzip
, bzip2
, gnutar
, p7zip
, cabextract
, cramfsprogs
, cramfsswap
, sasquatch
, squashfsTools
, lzma
, matplotlib
, nose
, pycrypto
, pyqtgraph
, visualizationSupport ? false }:

buildPythonPackage rec {
  pname = "binwalk";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "ReFirmLabs";
    repo = "binwalk";
    rev = "v${version}";
    sha256 = "1bxgj569fzwv6jhcbl864nmlsi9x1k1r20aywjxc8b9b1zgqrlvc";
  };

  propagatedBuildInputs = [ zlib xz ncompress gzip bzip2 gnutar p7zip cabextract squashfsTools lzma pycrypto ]
  ++ lib.optionals visualizationSupport [ matplotlib pyqtgraph ]
  ++ lib.optionals (!stdenv.isDarwin) [ cramfsprogs cramfsswap sasquatch ];

  # setup.py only installs version.py during install, not test
  postPatch = ''
    echo '__version__ = "${version}"' > src/binwalk/core/version.py
  '';

  # binwalk wants to access ~/.config/binwalk/magic
  preCheck = ''
    HOME=$(mktemp -d)
  '';

  checkInputs = [ nose ];

  pythonImportsCheck = [ "binwalk" ];

  meta = with lib; {
    homepage = "https://github.com/ReFirmLabs/binwalk";
    description = "A tool for searching a given binary image for embedded files";
    maintainers = [ maintainers.koral ];
  };
}
