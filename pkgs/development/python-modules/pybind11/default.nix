{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, python
, pytest
, cmake
, numpy ? null
, eigen ? null
, scipy ? null
}:

buildPythonPackage rec {
  pname = "pybind11";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "pybind";
    repo = pname;
    rev = "v${version}";
    sha256 = "11b6dniri8m05spfd2a19irz82shf4sdca73566bniggrf3zclnf";
  };

  patches = [
    (fetchpatch {
      url = https://github.com/pybind/pybind11/commit/44a40dd61e5178985cfb1150cf05e6bfcec73042.patch;
      sha256 = "047nzyfsihswdva96hwchnp4gj2mlbiqvmkdnhxrfi9sji8x31ka";
    })
    (fetchpatch {
      name = "pytest-4-excinfo-fix.patch";
      url = https://github.com/pybind/pybind11/commit/9fd4712121fdbb6202a35be4c788525e6c8ab826.patch;
      sha256 = "07jjv8jlbszvr2grpm5xqxjac7jb0y68lgb1jcbb93k9vyp1hr33";
    })
  ];

  dontUseCmakeConfigure = true;

  checkInputs = [ pytest cmake ]
    ++ (lib.optional (numpy != null) numpy)
    ++ (lib.optional (eigen != null) eigen)
    ++ (lib.optional (scipy != null) scipy);
  checkPhase = ''
    cmake ${if eigen != null then "-DEIGEN3_INCLUDE_DIR=${eigen}/include/eigen3" else ""}
    make -j $NIX_BUILD_CORES pytest
  '';

  meta = {
    homepage = https://github.com/pybind/pybind11;
    description = "Seamless operability between C++11 and Python";
    longDescription = ''
      Pybind11 is a lightweight header-only library that exposes
      C++ types in Python and vice versa, mainly to create Python
      bindings of existing C++ code.
    '';
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.yuriaisaka ];
  };
}
