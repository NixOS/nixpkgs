{ lib, stdenv, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder, python
, fonttools, defcon, lxml, fs, unicodedata2, zopfli, brotlipy, fontpens
, brotli, fontmath, mutatormath, booleanoperations
, ufoprocessor, ufonormalizer, psautohint, tqdm
, setuptools-scm
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

  patches = [
    # Skip date-dependent test. See
    # https://github.com/adobe-type-tools/afdko/pull/1232
    # https://github.com/NixOS/nixpkgs/pull/98158#issuecomment-704321117
    (fetchpatch {
      url = "https://github.com/adobe-type-tools/afdko/commit/2c36ad10f9d964759f643e8ed7b0972a27aa26bd.patch";
      sha256 = "0p6a485mmzrbfldfbhgfghsypfiad3cabcw7qlw2rh993ivpnibf";
    })
    # fix tests for fonttools 4.21.1
    (fetchpatch {
      url = "https://github.com/adobe-type-tools/afdko/commit/0919e7454a0a05a1b141c23bf8134c67e6b688fc.patch";
      sha256 = "0glly85swyl1kcc0mi8i0w4bm148bb001jz1winz5drfrw3a63jp";
    })
  ];

  nativeBuildInputs = [ setuptools-scm ];

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
  preCheck = ''
    export PATH=$PATH:$out/bin

    # Update tests to match ufinormalizer-0.6.1 expectations:
    #   https://github.com/adobe-type-tools/afdko/issues/1418
    find tests -name layerinfo.plist -delete
  '';
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
