{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  p7zip,
  cabextract,
  zip,
  lzip,
  zpaq,
  gnutar,
  unar, # Free alternative to unrar
  gnugrep,
  diffutils,
  file,
  gzip,
  bzip2,
  xz,
}:

let
  compression-utilities = [
    p7zip
    gnutar
    unar
    cabextract
    zip
    lzip
    zpaq
    gzip
    gnugrep
    diffutils
    bzip2
    file
    xz
  ];
in
buildPythonPackage rec {
  pname = "patool";
  version = "2.4.0";
  format = "setuptools";

  #pypi doesn't have test data
  src = fetchFromGitHub {
    owner = "wummel";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-dWyC8uTVUb06liNcJaG4oK9wqIDmwAl6i6cg4XRRRdQ=";
  };

  postPatch = ''
    substituteInPlace patoolib/util.py \
      --replace "path = None" 'path = os.environ["PATH"] + ":${lib.makeBinPath compression-utilities}"'
  '';

  nativeCheckInputs = [ pytestCheckHook ] ++ compression-utilities;

  disabledTests = [
    "test_unzip"
    "test_unzip_file"
    "test_zip"
    "test_zip_file"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_ar" ];

  meta = with lib; {
    description = "portable archive file manager";
    mainProgram = "patool";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
