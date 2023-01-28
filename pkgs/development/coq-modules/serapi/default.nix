{ lib, fetchzip, mkCoqDerivation, coq, version ? null }:

let
  release = {
    "8.16.0+0.16.0".sha256 = "sha256-Of5vO6wvqGyxagjGuuY3qCiLKbBr3VzLHiIn9U2R21E=";
    "8.15.0+0.15.0".sha256 = "1vh99ya2dq6a8xl2jrilgs0rpj4j227qx8zvzd2v5xylx0p4bbrp";
    "8.14.0+0.14.0".sha256 = "1kh80yb791yl771qbqkvwhbhydfii23a7lql0jgifvllm2k8hd8d";
    "8.13.0+0.13.0".sha256 = "0k69907xn4k61w4mkhwf8kh8drw9pijk9ynijsppihw98j8w38fy";
    "8.12.0+0.12.1".sha256 = "048x3sgcq4h845hi6hm4j4dsfca8zfj70dm42w68n63qcm6xf9hn";
    "8.11.0+0.11.1".sha256 = "1phmh99yqv71vlwklqgfxiq2vj99zrzxmryj2j4qvg5vav3y3y6c";
    "8.10.0+0.7.2".sha256  = "1ljzm63hpd0ksvkyxcbh8rdf7p90vg91gb4h0zz0941v1zh40k8c";
  };
in

(with lib; mkCoqDerivation rec {
  pname = "serapi";
  inherit version release;

  defaultVersion =  with versions;
    lib.switch coq.version [
      { case = isEq "8.16"; out = "8.16.0+0.16.0"; }
      { case = isEq "8.15"; out = "8.15.0+0.15.0"; }
      { case = isEq "8.14"; out = "8.14.0+0.14.0"; }
      { case = isEq "8.13"; out = "8.13.0+0.13.0"; }
      { case = isEq "8.12"; out = "8.12.0+0.12.1"; }
      { case = isEq "8.11"; out = "8.11.0+0.11.1"; }
      { case = isEq "8.10"; out = "8.10.0+0.7.2";  }
    ] null;

  useDune = true;

  patches = [ ./janestreet-0.15.patch ];

  propagatedBuildInputs =
    with coq.ocamlPackages; [
      cmdliner
      findlib # run time dependency of SerAPI
      ppx_deriving
      ppx_deriving_yojson
      ppx_import
      ppx_sexp_conv
      sexplib
      yojson
      zarith # needed because of Coq
    ];

  installPhase = ''
    runHook preInstall
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR coq-serapi
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/ejgallego/coq-serapi";
    description = "SerAPI is a library for machine-to-machine interaction with the Coq proof assistant";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.Zimmi48 ];
  };
}).overrideAttrs(o:
  let inherit (o) version; in {
  src = fetchzip {
    url =
        "https://github.com/ejgallego/coq-serapi/releases/download/${version}/coq-serapi-${
          if version == "8.11.0+0.11.1" then version
          else builtins.replaceStrings [ "+" ] [ "." ] version
        }.tbz";
    sha256 = release."${version}".sha256;
  };

  patches =
    if version == "8.10.0+0.7.2"
    then [
      ./8.10.0+0.7.2.patch
    ]
    else if version == "8.11.0+0.11.1"
    then [
      ./8.11.0+0.11.1.patch
    ]
    else if version == "8.12.0+0.12.1" || version == "8.13.0+0.13.0"
    then [
      ./8.12.0+0.12.1.patch
    ]
    else if version == "8.14.0+0.14.0" || version == "8.15.0+0.15.0"
    then [
      ./janestreet-0.15.patch
    ]
    else [
    ];

    propagatedBuildInputs = o.propagatedBuildInputs ++
      lib.optional (version == "8.16.0+0.16.0" || version == "dev") coq.ocamlPackages.ppx_hash
    ;

})
