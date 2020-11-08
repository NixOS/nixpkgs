#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash -p nix

BASE_URL_CISC="https://hg.openjdk.java.net/jdk8u/jdk8u"
BASE_URL_RISC="https://hg.openjdk.java.net/aarch64-port/jdk8u-shenandoah"

FILE_SUFFIX_CISC="jdk8u272-b10"
FILE_SUFFIX_RISC="aarch64-shenandoah-$FILE_SUFFIX_CISC"

modules=(
    "langtools"
    "hotspot"
    "corba"
    "jdk"
    "jaxws"
    "jaxp"
    "nashorn"
)

echo "  jdk8 = fetchSrc {"
echo "    cisc = \"$(nix-prefetch-url --type sha256 "${BASE_URL_CISC}/archive/${FILE_SUFFIX_CISC}.tar.gz")\";"
echo "    risc = \"$(nix-prefetch-url --type sha256 "${BASE_URL_RISC}/archive/${FILE_SUFFIX_RISC}.tar.gz")\";"
echo "  };"
echo
echo "  moduleSrcs = mapAttrs fetchModuleSrc {"
for module in "${modules[@]}"; do
    echo "    $module = {"
    echo "      cisc = \"$(nix-prefetch-url --type sha256 "${BASE_URL_CISC}/$module/archive/${FILE_SUFFIX_CISC}.tar.gz")\";"
    echo "      risc = \"$(nix-prefetch-url --type sha256 "${BASE_URL_RISC}/$module/archive/${FILE_SUFFIX_RISC}.tar.gz")\";"
    echo "    };"
done
echo "  };"
