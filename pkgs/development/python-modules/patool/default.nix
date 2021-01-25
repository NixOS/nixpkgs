{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, p7zip,
  unzip, cabextract, zip, zopfli, lzip, zpaq, gnutar, gnugrep, diffutils, file,
  gzip, bzip2, xz}:

# unrar is unfree, as well as 7z with unrar support, not including it (patool doesn't support unar)

let
  compression-utilities = [
    p7zip
    unzip
    gnutar
    cabextract
    zip
    zopfli
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

  prePatch = ''
    substituteInPlace patoolib/util.py \
      --replace "path = None" 'path = append_to_path(os.environ["PATH"], "${lib.makeBinPath compression-utilities}")'
  '';

  checkInputs = [ pytestCheckHook ] ++ compression-utilities;

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
