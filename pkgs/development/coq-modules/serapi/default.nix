{ lib, fetchzip, mkCoqDerivation, coq, coq-lsp, version ? null }:

let
  release = {
    "8.19.0+0.19.3".sha256 = "sha256-QWRXBTcjtAGskZBeLIuX7WDE95KfH6SxV8MJSMx8B2Q=";
    "8.18.0+0.18.3".sha256 = "sha256-3JGZCyn62LYJVpfXiwnSMxvdA2vQNTL7li2ZBPcjF0M=";
    "8.17.0+0.17.3".sha256 = "sha256-XolzpJd8zs4LLyJO4eWvCiAJ0HJSGBJTGVSBClQRGnw=";
    "8.16.0+0.16.3".sha256 = "sha256-22Kawp8jAsgyBTppwN5vmN7zEaB1QfPs0qKxd6x/7Uc=";
    "8.15.0+0.15.0".sha256 = "1vh99ya2dq6a8xl2jrilgs0rpj4j227qx8zvzd2v5xylx0p4bbrp";
    "8.14.0+0.14.0".sha256 = "1kh80yb791yl771qbqkvwhbhydfii23a7lql0jgifvllm2k8hd8d";
    "8.13.0+0.13.0".sha256 = "0k69907xn4k61w4mkhwf8kh8drw9pijk9ynijsppihw98j8w38fy";
    "8.12.0+0.12.1".sha256 = "048x3sgcq4h845hi6hm4j4dsfca8zfj70dm42w68n63qcm6xf9hn";
    "8.11.0+0.11.1".sha256 = "1phmh99yqv71vlwklqgfxiq2vj99zrzxmryj2j4qvg5vav3y3y6c";
    "8.10.0+0.7.2".sha256  = "1ljzm63hpd0ksvkyxcbh8rdf7p90vg91gb4h0zz0941v1zh40k8c";
  };
in

(mkCoqDerivation {
  pname = "serapi";
  repo = "coq-serapi";
  inherit version release;

  defaultVersion = lib.switch coq.version [
      { case = lib.versions.isEq "8.19"; out = "8.19.0+0.19.3"; }
      { case = lib.versions.isEq "8.18"; out = "8.18.0+0.18.3"; }
      { case = lib.versions.isEq "8.17"; out = "8.17.0+0.17.3"; }
      { case = lib.versions.isEq "8.16"; out = "8.16.0+0.16.3"; }
      { case = lib.versions.isEq "8.15"; out = "8.15.0+0.15.0"; }
      { case = lib.versions.isEq "8.14"; out = "8.14.0+0.14.0"; }
      { case = lib.versions.isEq "8.13"; out = "8.13.0+0.13.0"; }
      { case = lib.versions.isEq "8.12"; out = "8.12.0+0.12.1"; }
      { case = lib.versions.isEq "8.11"; out = "8.11.0+0.11.1"; }
      { case = lib.versions.isEq "8.10"; out = "8.10.0+0.7.2";  }
    ] null;

  useDune = true;

  propagatedBuildInputs =
    with coq.ocamlPackages; [
      cmdliner
      findlib # run time dependency of SerAPI
      ppx_deriving
      ppx_import
      ppx_sexp_conv
      ppx_hash
      sexplib
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
    maintainers = with maintainers; [ alizter Zimmi48 ];
  };
}).overrideAttrs(o:
if lib.versions.isLe "8.19.0+0.19.3" o.version && o.version != "dev" then
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
    else if version == "8.16.0+0.16.3" || version == "8.17.0+0.17.0"
    then [
      ./janestreet-0.16.patch
    ]
    else [
    ];

    propagatedBuildInputs = o.propagatedBuildInputs
      ++ (with coq.ocamlPackages; [ ppx_deriving_yojson yojson zarith ])  # zarith needed because of Coq
    ; }
else
  { propagatedBuildInputs = o.propagatedBuildInputs ++ [ coq-lsp ]; }
)
