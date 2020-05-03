{ lib
, buildPythonPackage
, fetchFromGitHub
, taglib
, cython
, pytest
, glibcLocales
, fetchpatch
}:

buildPythonPackage rec {
  pname   = "pytaglib";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "supermihi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1gvvadlgk8ny8bg76gwvvfcwp1nfgrjphi60h5f9ha7h5ff1g2wb";
  };

  patches = [
    # fix tests on python 2.7
    (fetchpatch {
      url = "https://github.com/supermihi/pytaglib/commit/0c4ae750fcd5b18d2553975c7e3e183e9dca5bf1.patch";
      sha256 = "1kv3c68vimx5dc8aacvzphiaq916avmprxddi38wji8p2ql6vngj";
    })

    # properly install pyprinttags
    (fetchpatch {
      url = "https://github.com/supermihi/pytaglib/commit/ba7a1406ddf35ddc41ed57f1c8d1f2bc2ed2c93a.patch";
      sha256 = "0pi0dcq7db5fd3jnbwnfsfsgxvlhnm07z5yhpp93shk0s7ci2bwp";
    })
    (fetchpatch {
      url = "https://github.com/supermihi/pytaglib/commit/28772f6f94d37f05728071381a0fa04c6a14783a.patch";
      sha256 = "0h259vzj1l0gpibdf322yclyd10x5rh1anzhsjj2ghm6rj6q0r0m";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "'pytest-runner', " ""
  '';

  buildInputs = [ taglib cython ];

  checkInputs = [ pytest glibcLocales ];

  checkPhase = ''
    LC_ALL=en_US.utf-8 pytest .
  '';

  meta = {
    homepage = "https://github.com/supermihi/pytaglib";
    description = "Python 2.x/3.x bindings for the Taglib audio metadata library";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.mrkkrp ];
  };
}
