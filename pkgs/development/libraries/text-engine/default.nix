{ stdenv
, lib
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, json-glib
, gtk4
, libxml2
, gobject-introspection
, pkg-config
, libadwaita
}:

stdenv.mkDerivation rec {
  pname = "text-engine";
  version = "0.1.1";
  src = fetchFromGitHub {
    owner = "mjakeman";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-YSG4Vk3hrmtaJkK1WAlQcdgiDdgC4Un0t6UdaoIcUes=";
  };

  patches = [
    # Fixes build with newer versions of clang
    (fetchpatch {
      url = "https://github.com/mjakeman/text-engine/commit/749c94d853c0b0e29e79a1b270ec61947b65c319.patch";
      hash = "sha256-vs/a8IBovArw8tc1ZLUsaDHRVyA71KMB1NGENOKNOdk=";
    })
  ];

  nativeBuildInputs = [ gobject-introspection gtk4 meson ninja pkg-config ];

  buildInputs = [ libadwaita json-glib libxml2 ];

  meta = with lib; {
    description = "Rich text framework for GTK";
    mainProgram = "text-engine-demo";
    homepage = "https://github.com/mjakeman/text-engine";
    license = with licenses; [ mpl20 lgpl21Plus ];
    maintainers = with maintainers; [ foo-dogsquared ];
  };
}
