{ lib
, stdenv
, fetchFromGitHub
, ocaml
, pkg-config
, solo5
, target ? "xen"
}:

# note: this is not technically an ocaml-module,
# but can be built with different compilers, so
# the ocamlPackages set is very useful.

let
  pname = "ocaml-freestanding";
in

if lib.versionOlder ocaml.version "4.08"
then builtins.throw "${pname} is not available for OCaml ${ocaml.version}"
else

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  inherit pname;
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "mirage";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256:1mbyjzwcs64n7i3xkkyaxgl3r46drbl0gkqf3fqgm2kh3q03638l";
  };

  postUnpack = ''
    # get ocaml-src from the ocaml drv instead of via ocamlfind
    mkdir -p "${src.name}/ocaml"
    tar --strip-components=1 -xf ${ocaml.src} -C "${src.name}/ocaml"
  '';

  patches = [
    ./no-opam.patch
    ./configurable-binding.patch
  ];

  nativeBuildInputs = [
    ocaml
    pkg-config
  ];

  propagatedBuildInputs = [ solo5 ];

  configurePhase = ''
    runHook preConfigure
    env PKG_CONFIG_DEPS=solo5-bindings-${target} sh configure.sh
    runHook postConfigure
  '';

  installPhase = ''
    runHook preInstall
    ./install.sh "$out"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Freestanding OCaml runtime";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
    homepage = "https://github.com/mirage/ocaml-freestanding";
    platforms = builtins.map ({ arch, os }: "${arch}-${os}")
      (cartesianProductOfSets {
          arch = [ "aarch64" "x86_64" ];
          os = [ "linux" ];
      } ++ [
        { arch = "x86_64"; os = "freebsd"; }
        { arch = "x86_64"; os = "openbsd"; }
      ]);
  };
}
