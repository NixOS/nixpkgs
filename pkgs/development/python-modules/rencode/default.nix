{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "rencode";
  version = "unstable-2021-08-10";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aresch";
    repo = "rencode";
    rev = "572ff74586d9b1daab904c6f7f7009ce0143bb75";
    hash = "sha256-cL1hV3RMDuSdcjpPXXDYIEbzQrxiPeRs82PU8HTEQYk=";
  };

  nativeBuildInputs = [ cython ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # import from $out
    rm -r rencode
  '';

  meta = with lib; {
    homepage = "https://github.com/aresch/rencode";
    description = "Fast (basic) object serialization similar to bencode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
