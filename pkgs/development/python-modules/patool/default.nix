{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, p7zip,
  cabextract, zip, lzip, zpaq, gnutar, gnugrep, diffutils, file,
  gzip, bzip2, xz}:

# unrar is unfree, as well as 7z with unrar support, not including it (patool doesn't support unar)
# it will still use unrar if present in the path

let
  compression-utilities = [
    p7zip
    gnutar
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
  version = "1.12";

  #pypi doesn't have test data
  src = fetchFromGitHub {
    owner = "wummel";
    repo = pname;
    rev = "upstream/${version}";
    sha256 = "0v4r77sm3yzh7y1whfwxmp01cchd82jbhvbg9zsyd2yb944imzjy";
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
  ];

  meta = with lib; {
    description = "portable archive file manager";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
