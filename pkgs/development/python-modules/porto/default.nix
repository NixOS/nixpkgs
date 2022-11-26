{ lib
, fetchFromGitHub
, buildPythonPackage
, pypandoc
, markdown
, bleach
, nbformat
, jupyter-client
, pygobject3
, ipykernel
, gtk3
, webkitgtk
, gtksourceview
, gobject-introspection
, wrapGAppsHook
}:

# Added as a python package instead of an application
# because in this way it can be easily added to a python environment
# like this: python3.withPackages (p: with p; [ numpy porto ])
# and I think in general this is easier to compose

buildPythonPackage rec {
  pname = "porto";
  version = "0.0.2";

  format = "other";

  src = fetchFromGitHub {
    owner = "cvfosammmm";
    repo = "Porto";
    rev = "v${version}";
    hash = "sha256-akkPs8iz7RYdhiGau4Dsm1LzN/e/IJ+ZjyhKJrF44jM=";
  };

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    webkitgtk
    gtksourceview
  ];

  propagatedBuildInputs = [
    pypandoc
    markdown
    bleach
    nbformat
    jupyter-client
    pygobject3
    ipykernel
  ];

  installPhase = ''
    runHook preInstall
    install -Dm444 resources/org.cvfosammmm.Porto.desktop -t $out/share/applications/
    install -Dm444 resources/images/org.cvfosammmm.Porto.svg -t $out/share/icons/hicolor/scalable/apps/
    install -Dm444 resources/org.cvfosammmm.Porto.appdata.xml -t $out/share/metainfo/
    mkdir -p $out/share/porto/
    cp -r app cell dialogs helpers resources result_factory notebook workspace $out/share/porto/
    install -Dm555 __main__.py -T $out/bin/porto
    runHook postInstall
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PYTHONPATH : $out/share/porto
    )
  '';

  meta = with lib; {
    description = "Run and edit Jupyter notebooks on the desktop, written in Python with Gtk";
    homepage = "https://www.cvfosammmm.org/porto/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
