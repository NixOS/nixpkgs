{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pytestCheckHook
, p7zip
, cabextract
, zip
, lzip
, zpaq
, gnutar
, gnugrep
, diffutils
, file
, gzip
, bzip2
, xz
}:

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
  format = "setuptools";

  #pypi doesn't have test data
  src = fetchFromGitHub {
    owner = "wummel";
    repo = pname;
    rev = "upstream/${version}";
    hash = "sha256-Xv4aCUnLi+b1T29tuKRADTIWwK2dO8iDP/D7UfU5mWw=";
  };

  patches = [
    # https://github.com/wummel/patool/pull/63
    (fetchpatch {
      name = "apk-sometimes-has-mime-jar.patch";
      url = "https://github.com/wummel/patool/commit/a9f3ee3d639a1065be024001e89c0b153511b16b.patch";
      hash = "sha256-a4aWqHHc/cBs5T2QKZ08ky1K1tqKZEgqVmTmV11aTVE=";
    })
    # https://github.com/wummel/patool/pull/130
    (fetchpatch {
      name = "apk-sometimes-has-mime-android-package.patch";
      url = "https://github.com/wummel/patool/commit/e8a1eea1d273b278a1b6f5029d2e21cb18bc9ffd.patch";
      hash = "sha256-AVooVdU4FNIixUfwyrn39N2SDFHNs4CUYzS5Eey+DrU=";
    })
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
  ];

  meta = with lib; {
    description = "portable archive file manager";
    homepage = "https://wummel.github.io/patool/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ marius851000 ];
  };
}
