#! /bin/sh

cd $(dirname $0);

source lib-cache.sh;

print_expression () {
    module_name="$1";
    module_basename="${module_name//::/-}";
    module_compressedname="perl${module_name//::/}";
    sourcelink="$(./source-download-link.sh "${module_name}")";
    version_name="${sourcelink%.tar.*}";
    version_name="${version_name##*/}";
    dependencies="$(./filtered-requirements.sh "$module_name" | sed -e 's/^/perl/; s/:://g' | xargs)";
    source_hash=$(nix-prefetch-url "$sourcelink" 2>/dev/null);

    cat <<EOF

  ${module_compressedname} = import ../development/perl-modules/generic perl {
    name = "${version_name}";
    src = fetchurl {
      url = ${sourcelink};
      sha256 = "$source_hash";
    };
    propagatedBuildInputs = [${dependencies}];
  };

EOF
};

module_name="$1";
module_basename="${module_name//::/-}";

cached_output print_expression "$module_basename" "$module_name" "nix";
