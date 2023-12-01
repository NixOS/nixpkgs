#! /bin/sh

source lib-cache.sh;

module_name="$1";
module_basename="${module_name//::/-}";

write_link() {
    module_basename="$1";

    ./retrieve-modulepage.sh "$module_basename" |
        grep -A 2 "This Release" |
        grep href |
        sed -re 's/.*href="//; s/".*//; s@^/@http://search.cpan.org/@';
}

cached_output write_link "$module_basename" "$module_basename" src.link;
