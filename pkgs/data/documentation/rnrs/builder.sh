source "$stdenv/setup" || exit 1

# XXX: Eventually we could consider building the PDF/PS files as well.

echo "source is \`$src', report name is \`$reportName'"

ensureDir "$out/share/info" &&					\
makeinfo -o "$out/share/info/${reportName}.info" "$src"

# XXX: HTML output is apparently broken.
#ensureDir "$out/share/doc/${reportName}" &&			\
#makeinfo -o "$out/share/doc/${reportName}/html" --html --force "$src"
