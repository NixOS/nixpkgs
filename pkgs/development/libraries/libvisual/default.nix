{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, SDL
, autoreconfHook
, autoconf-archive
, glib
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libvisual";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "Libvisual";
    repo = pname;
    rev = "${pname}-${version}";
    hash = "sha256-bDnpQODXB2Z6hezVoh7c6cklp6qpyDzVBAnwZD8Gros=";
  };

  sourceRoot = "${src.name}/${pname}";

  outputs = [ "out" "dev" ];

  strictDeps = true;
  nativeBuildInputs = [ autoreconfHook autoconf-archive pkg-config ];
  buildInputs = [ SDL glib ];

  configureFlags = lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    # Remove once "sdl-cross-prereq.patch" patch above is removed.
    "--disable-lv-tool"
  ] ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  meta = {
    description = "Abstraction library for audio visualisations";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
