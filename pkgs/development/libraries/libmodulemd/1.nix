{ libmodulemd, fetchurl }:

libmodulemd.overrideAttrs(old: rec {
  name = "libmodulemd-${version}";
  version = "1.8.15";

  # Removes py output since there's no overrides here
  outputs = [ "out" "devdoc" ];

  patches = [
    # Checks for glib docs in glib's prefix
    # but they're installed to another
    ./dont-check-docs.patch
  ];

  src = fetchurl {
    url = "https://github.com/fedora-modularity/libmodulemd/releases/download/${name}/modulemd-${version}.tar.xz";
    sha256 = "0gz8p3qzji3cx0r57sy3gn4dhigg4k7pcxj3lmjcjn13vxh5rm7z";
  };

})
