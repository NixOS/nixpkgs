{ lib, stdenv, fetchurl, unzip, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner, uucd }:
let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
  version = "13.0.0";
  ucdxml = fetchurl {
    url = "http://www.unicode.org/Public/${version}/ucdxml/ucd.all.grouped.zip";
    sha256 = "04gpl09ggb6fb0kmk6298rd8184dv6vcscn28l1gpdv1yjlw1a8q";
  };
  gen = fetchurl {
    url = "https://raw.githubusercontent.com/dbuenzli/uunf/v12.0.0/support/gen.ml";
    sha256 = "08j2mpi7j6q3rqc6bcdwspqn1s7pkkphznxfdycqjv4h9yaqsymj";
  };
  gen_norm = fetchurl {
    url = "https://raw.githubusercontent.com/dbuenzli/uunf/v12.0.0/support/gen_norm.ml";
    sha256 = "11vx5l5bag6bja7qj8jv4s2x9fknj3557n0mj87k2apq5gs5f4m5";
  };
  gen_props = fetchurl {
    url = "https://raw.githubusercontent.com/dbuenzli/uunf/v12.0.0/support/gen_props.ml";
    sha256 = "0a6lhja498kp9lxql0pbfvkgvajs10wx88wkqc7y5m3lrvw46268";
  };
in

assert lib.versionAtLeast ocaml.version "4.03";

stdenv.mkDerivation {
  name = "ocaml-${pname}-${version}";
  inherit version;

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1qci04nkp24kdls1z4s8kz5dzgky4nwd5r8345nwdrgwmxhw7ksm";
  };

  postConfigure = ''
    rm -f src/uunf_data.ml
    mkdir -p support/
    cp ${gen} support/gen.ml
    cp ${gen_norm} support/gen_norm.ml
    cp ${gen_props} support/gen_props.ml
    funzip ${ucdxml} > support/ucd.xml
    ocaml -I ${findlib}/lib/ocaml/${ocaml.version}/site-lib/ pkg/build_support.ml
  '';

  nativeBuildInputs = [ unzip ];

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf cmdliner uucd ];

  propagatedBuildInputs = [ uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    # See https://github.com/dbuenzli/uunf/issues/15#issuecomment-903151264
    broken = lib.versions.majorMinor ocaml.version == "4.08"
      && stdenv.hostPlatform.isAarch64;
  };
}
