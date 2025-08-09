{
  stdenv,
  lib,
  fetchFromGitHub,
  elkhound,
  ocaml-ng,
  perl,
  which,
  fetchpatch,
}:

let
  # 1. Needs ocaml >= 4.04 and <= 4.11 but works with 4.14 when patched
  # 2. ocaml 4.10+ defaults to safe (immutable) strings so we need a version with
  #    that disabled as weidu is strongly dependent on mutable strings
  ocaml' = ocaml-ng.ocamlPackages_4_14_unsafe_string.ocaml;

in
stdenv.mkDerivation rec {
  pname = "weidu";
  version = "249.00";

  src = fetchFromGitHub {
    owner = "WeiDUorg";
    repo = "weidu";
    rev = "v${version}";
    sha256 = "sha256-+vkKTzFZdAzY2dL+mZ4A0PDxhTKGgs9bfArz7S6b4m4=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/WeiDUorg/weidu/commit/bb90190d8bf7d102952c07d8288a7dc6c7a3322e.patch";
      hash = "sha256-Z4hHdMR1dYjJeERJSqlYynyPu2CvE6+XJuCr9ogDmvk=";
    })
  ];

  postPatch = ''
    substitute sample.Configuration Configuration \
      --replace-fail /usr/bin ${lib.makeBinPath [ ocaml' ]} \
      --replace-fail /usr/local/bin ${lib.makeBinPath [ ocaml' ]} \
      --replace-fail elkhound ${lib.getExe elkhound}

    mkdir -p obj/{.depend,x86_LINUX}

    # undefined reference to `caml_hash_univ_param'
    sed -i "20,21d;s/old_hash_param/hash_param/" hashtbl-4.03.0/myhashtbl.ml
  '';

  nativeBuildInputs = [
    elkhound
    ocaml'
    perl
    which
  ];

  buildFlags = [
    "weidu"
    "weinstall"
    "tolower"
  ];

  installPhase = ''
    runHook preInstall

    for b in tolower weidu weinstall; do
      install -Dm555 $b.asm.exe $out/bin/$b
    done

    install -Dm444 -t $out/share/doc/weidu README* COPYING

    runHook postInstall
  '';

  meta = with lib; {
    description = "InfinityEngine Modding Engine";
    homepage = "https://weidu.org";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    # should work fine on Windows
    platforms = platforms.unix;
    mainProgram = "weidu";
  };
}
