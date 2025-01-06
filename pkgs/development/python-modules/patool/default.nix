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
  version = "3.1.0";
  format = "setuptools";

  #pypi doesn't have test data
  src = fetchFromGitHub {
    owner = "wummel";
    repo = pname;
    tag = version;
    hash = "sha256-mt/GUIRJHB2/Rritc+uNkolZzguYy2G/NKnSKNxKsLk=";
  };

  patches = [
    # https://github.com/wummel/patool/pull/173
    ./fix-rar-detection.patch
  ];

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
    "test_7z"
    "test_7z_file"
    "test_7za_file"
    "test_p7azip"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ "test_ar" ];

  meta = with lib; {
    description = "portable archive file manager";
    mainProgram = "patool";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
