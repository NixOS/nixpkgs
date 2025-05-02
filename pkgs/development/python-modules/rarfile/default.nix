{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook, nose, libarchive, glibcLocales, isPy27
# unrar is non-free software
, useUnrar ? false, unrar
}:

assert useUnrar -> unrar != null;
assert !useUnrar -> libarchive != null;

buildPythonPackage rec {
  pname = "rarfile";
  version = "4.2";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "markokr";
    repo = "rarfile";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZiwD2LG25fMd4Z+QWsh/x3ceG5QRBH4s/TZDwMnfpNI=";
  };

  nativeCheckInputs = [ pytestCheckHook nose glibcLocales ];

  prePatch = ''
    substituteInPlace rarfile.py \
  '' + (if useUnrar then
        ''--replace 'UNRAR_TOOL = "unrar"' "UNRAR_TOOL = \"${unrar}/bin/unrar\""
        ''
       else
        ''--replace 'ALT_TOOL = "bsdtar"' "ALT_TOOL = \"${libarchive}/bin/bsdtar\""
        '')
     + "";
  # the tests only work with the standard unrar package
  doCheck = useUnrar;
  LC_ALL = "en_US.UTF-8";
  pythonImportsCheck = [ "rarfile" ];

  meta = with lib; {
    description = "RAR archive reader for Python";
    homepage = "https://github.com/markokr/rarfile";
    license = licenses.isc;
  };
}
