{ stdenv, lib, fetchFromGitHub, fetchpatch, ocaml, findlib, ocamlbuild
, ocaml_lwt # optional lwt support
, ounit, fileutils # only for tests
}:

stdenv.mkDerivation rec {
  version = "2.3";
  pname = "ocaml${ocaml.version}-inotify";

  src = fetchFromGitHub {
    owner = "whitequark";
    repo = "ocaml-inotify";
    rev = "v${version}";
    sha256 = "1s6vmqpx19hxzsi30jvp3h7p56rqnxfhfddpcls4nz8sqca1cz5y";
  };

  patches = [ (fetchpatch {
    url = "https://github.com/whitequark/ocaml-inotify/commit/716c8002cc1652f58eb0c400ae92e04003cba8c9.patch";
    sha256 = "04lfxrrsmk2mc704kaln8jqx93jc4bkxhijmfy2d4cmk1cim7r6k";
  }) ];

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ ocaml_lwt ];
  checkInputs = [ ounit fileutils ];

  # Otherwise checkInputs can't be found
  strictDeps = false;

  configureFlags = [ "--enable-lwt"
    (lib.optionalString doCheck "--enable-tests") ];

  postConfigure = lib.optionalString doCheck ''
    echo '<lib_test/test_inotify_lwt.*>: pkg_threads' | tee -a _tags
  '';

  doCheck = true;
  checkTarget = "test";

  createFindlibDestdir = true;

  meta = {
    description = "Bindings for Linux’s filesystem monitoring interface, inotify";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
    inherit (src.meta) homepage;
    platforms = lib.platforms.linux;
  };
}
