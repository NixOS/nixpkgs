#! /bin/sh

module_basename="$1";
file_name="$2";

version_regexp="${module_basename}(-[0-9.a-z]+){0,1}";
author_regexp="[A-Z0-9]+";

./retrieve-modulepage.sh "$module_basename" |
    egrep "[<]a href=\"[a-z0-9/]*/(${author_regexp}/){0,1}${version_regexp}/${file_name}" |
    sed -re "s@.*href=\"@@; s@\".*@@" |
    sed -re 's@^/@http://search.cpan.org/@';

echo "$link_line";
