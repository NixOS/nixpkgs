. $stdenv/setup

mkdir -p $out/xml/dtd/docbook-ebnf
cd $out/xml/dtd/docbook-ebnf
stripHash $dtd
cp -p $dtd $strippedName
stripHash $catalog
cp -p $catalog $strippedName
