{ lib, stdenv, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder, python
, fonttools, defcon, lxml, fs, unicodedata2, zopfli, brotlipy, fontpens
, brotli, fontmath, booleanoperations
, ufoprocessor, ufonormalizer, psautohint, tqdm
, setuptools_scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "3.6.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gb8yywrakilj08pbwnbnw2df0rirz15k4y33ch7sp1fl7x0k4y7";
  };

  patches = [
    # fix tests for fonttools 4.21.1
    (fetchpatch {
      url = "https://github.com/adobe-type-tools/afdko/commit/0919e7454a0a05a1b141c23bf8134c67e6b688fc.patch";
      sha256 = "0glly85swyl1kcc0mi8i0w4bm148bb001jz1winz5drfrw3a63jp";
    })
  ];

  nativeBuildInputs = [ setuptools_scm ];

  propagatedBuildInputs = [
    booleanoperations
    fonttools
    lxml           # fonttools[lxml], defcon[lxml] extra
    fs             # fonttools[ufo] extra
    unicodedata2   # fonttools[unicode] extra
    brotlipy       # fonttools[woff] extra
    zopfli         # fonttools[woff] extra
    fontpens
    brotli
    defcon
    fontmath
    ufoprocessor
    ufonormalizer
    psautohint
    tqdm
  ];

  # tests are broken on non x86_64
  # https://github.com/adobe-type-tools/afdko/issues/1163
  # https://github.com/adobe-type-tools/afdko/issues/1216
  doCheck = stdenv.isx86_64;
  checkInputs = [ pytestCheckHook ];
  preCheck = "export PATH=$PATH:$out/bin";
  disabledTests = [
    # Disable slow tests, reduces test time ~25 %
    "test_report"
    "test_post_overflow"
    "test_cjk"
    "test_extrapolate"
    "test_filename_without_dir"
    "test_overwrite"
    "test_options"
  ];

  meta = with lib; {
    description = "Adobe Font Development Kit for OpenType";
    homepage = "https://adobe-type-tools.github.io/afdko/";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
