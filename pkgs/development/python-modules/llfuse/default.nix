{ stdenv, fetchurl, fetchpatch, buildPythonPackage, pkgconfig, pytest, fuse, attr, which
, contextlib2, osxfuse
}:

let
  inherit (stdenv.lib) optionals optionalString;
in

buildPythonPackage rec {
  pname = "llfuse";
  version = "1.3.6";

  src = fetchurl {
    url = "mirror://pypi/l/llfuse/${pname}-${version}.tar.bz2";
    sha256 = "1j9fzxpgmb4rxxyl9jcf84zvznhgi3hnh4hg5vb0qaslxkvng8ii";
  };

  patches = [
    # https://github.com/python-llfuse/python-llfuse/pull/23 (2 commits)
    (fetchpatch {
      url = "https://github.com/python-llfuse/python-llfuse/commit/7579b0e626da1a7882b13caedcdbd4a834702e94.diff";
      sha256 = "0vpybj4k222h20lyn0q7hz86ziqlapqs5701cknw8d11jakbhhb0";
    })
    (fetchpatch {
      url = "https://github.com/python-llfuse/python-llfuse/commit/438c00ab9e10d6c485bb054211c01b7f8524a736.diff";
      sha256 = "1zhb05b7k3c9mjqshy9in8yzpbihy7f33x1myq5kdjip1k50cwrn";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs =
    optionals stdenv.isLinux [ fuse ]
    ++ optionals stdenv.isDarwin [ osxfuse ];
  checkInputs = [ pytest which ] ++
    optionals stdenv.isLinux [ attr ];

  propagatedBuildInputs = [ contextlib2 ];

  checkPhase = ''
    py.test -k "not test_listdir" ${optionalString stdenv.isDarwin ''-m "not uses_fuse"''}
  '';

  meta = with stdenv.lib; {
    description = "Python bindings for the low-level FUSE API";
    homepage = https://github.com/python-llfuse/python-llfuse;
    license = licenses.lgpl2Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
