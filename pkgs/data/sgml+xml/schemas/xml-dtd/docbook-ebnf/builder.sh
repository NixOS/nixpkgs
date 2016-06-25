source $stdenv/setup

mkdir -p $out/xml/dtd/docbook-ebnf
cd $out/xml/dtd/docbook-ebnf
cp -p $dtd dbebnf.dtd
stripHash $catalog
cp -p $catalog $strippedName
