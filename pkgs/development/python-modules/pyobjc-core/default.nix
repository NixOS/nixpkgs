{
  lib,
  buildPythonPackage,
  setuptools,
  fetchFromGitHub,
  fetchpatch,
  darwin,
  unittestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyobjc-core";
  version = "10.3.1";
  src = fetchFromGitHub {
    owner = "ronaldoussoren";
    repo = "pyobjc";
    rev = "v${version}";
    hash = "sha256-1IpOaXQpBUxpErC5KR5k7bru6mbxNQSaiJLk9iz5tpg=";
  };
  pyproject = true;
  disabled = pythonOlder "3.9";
  build-system = [ setuptools ];

  sourceRoot = "${src.name}/pyobjc-core";

  patches = [
    # Two patches from upstream that will be incorporated in the next release
    ./patches/upstream-splitsig-nsurl.patch
    (fetchpatch {
      name = "002-splitsig.patch";
      url = "https://github.com/ronaldoussoren/pyobjc/commit/190fe5368a431e518921b9fc2dc9d9f221333924.patch";
      stripLen = 1;
      sha256 = "sha256-lzhPwN8SnLYmFWofsgX5lG6Kh6288xFRvFlmgN+exCM=";
    })
    # Fix or skip problematic tests
    ./patches/001-test_sockaddr.patch
    ./patches/002-test_no_such_selector.patch
    ./patches/003-test_struct_pickling.patch
    ./patches/004-test_assertPickleRoundTrips.patch
    ./patches/005-test_assert_opaque.patch
    # Some tests have an embedded class definition. Loading issues with these cause a segfault.
    ./patches/006-rm_embedded_classes.patch
  ];

  buildInputs = [
    darwin.libffi
  ];

  hardeningDisable = [ "strictoverflow" ]; # -fno-strict-overflow is not supported in clang on darwin
  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=deprecated-declarations" ];

  # IMPORTANT: unittest discovery segfaults when run in the sandbox. So disable it first, please.
  nativeCheckInputs = [
    darwin.DarwinTools
    unittestCheckHook
  ];

  unittestFlagsArray = [
    "-s"
    "PyObjCTest"
    "-v"
  ];

  preCheck = ''
    # unittest doesn't have disabled tests or test paths and several tests won't
    # load even with the custom test runner. Time for the sledge-o-matic.

    # Depends on missing test.pickletester
    rm PyObjCTest/test_archive_python.py
    # ImportError: cannot import name 'list_tests' from 'test'
    rm PyObjCTest/test_array_interface.py
    # ModuleNotFoundError: No module named 'distutils'. Supplying distutils causes a circular dependency on jaraco-path
    rm PyObjCTest/test_bridgesupport.py
    # 'PyObjCTest.test_object_property' not found on path
    rm PyObjCTest/test_array_property.py
    rm PyObjCTest/test_dict_property.py
    rm PyObjCTest/test_set_property.py

    # ImportError: attempted relative import with no known parent package
    rm PyObjCTest/test_bundleFunctions.py
    rm PyObjCTest/test_bundleVariables.py
    rm PyObjCTest/test_categories.py
    rm PyObjCTest/test_conversion.py
    rm PyObjCTest/test_enumerator.py
    rm PyObjCTest/test_generic_new.py
    rm PyObjCTest/test_methodaccess.py
    rm PyObjCTest/test_nsunavailable.py
    rm PyObjCTest/test_objc.py
    rm PyObjCTest/test_subclass.py
    rm PyObjCTest/test_vector_proxy.py
    rm PyObjCTest/test_weakref.py
    # ImportError: cannot import name 'mapping_tests' from 'test'
    rm PyObjCTest/test_dict_interface.py
    # ModuleNotFoundError: No module named 'test.test_set'
    rm PyObjCTest/test_set_interface.py
    # Py_MetaDataTest_AllArgs is overriding existing Objective-C class
    rm PyObjCTest/test_metadata_py2py.py
    # AttributeError: module 'decimal' has no attribute 'Decimal'
    rm PyObjCTest/test_nsdecimal.py
    # OCCopy is overriding existing Objective-C class
    rm PyObjCTest/test_object_property.py

    # Depends on the Quartz graphics framework being available
    rm PyObjCTest/test_transform.py
    rm PyObjCTest/test_vectorcall.py

    # Uncomment if you're getting segfaults when testing w/ sandbox = false
    # export PYOBJC_NO_AUTORELEASE=1

    export PYTHONPATH=$PYTHONPATH:Lib/PyObjCTools:Lib/objc
  '';

  pythonImportsCheck = [ "pyobjc-core" ];

  meta = {
    description = "Python <-> Objective-C Bridge with bindings for macOS frameworks";
    homepage = "https://github.com/ronaldoussoren/pyobjc";
    changelog = "https://github.com/ronaldoussoren/pyobjc/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.darwin;
    maintainers = [
      lib.maintainers.ferrine
      lib.maintainers.sarahec
    ];
  };
}
