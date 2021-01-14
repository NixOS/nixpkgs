{ lib, stdenv, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder, python
, fonttools, defcon, lxml, fs, unicodedata2, zopfli, brotlipy, fontpens
, brotli, fontmath, mutatormath, booleanoperations
, ufoprocessor, ufonormalizer, psautohint, tqdm
, setuptools_scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "3.5.1";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qg7dgl81yq0sp50pkhgvmf8az1svx20zmpkfa68ka9d0ssh1wjw";
  };

  # Skip date-dependent test. See
  # https://github.com/adobe-type-tools/afdko/pull/1232
  # https://github.com/NixOS/nixpkgs/pull/98158#issuecomment-704321117
  patches = [
    (fetchpatch {
      url = "https://github.com/adobe-type-tools/afdko/commit/2c36ad10f9d964759f643e8ed7b0972a27aa26bd.patch";
      sha256 = "0p6a485mmzrbfldfbhgfghsypfiad3cabcw7qlw2rh993ivpnibf";
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
    mutatormath
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
