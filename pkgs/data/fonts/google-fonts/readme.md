# google-fonts

## total size

```
uncompressed: 2 GB
tar.gz: 1 GB
.git: 1 GB
.git + files: 3 GB
```

## file count

```
find * -name "*.ttf" | wc -l
3460
```

## folder count

```
find * -name "*.ttf" | xargs dirname | sort | uniq | wc -l
1621
```

## unique folders

```
find * -name "*.ttf" | xargs dirname | xargs basename -a | sort | uniq | wc -l
1619
```

folder names are NOT unique

```
find * -name "*.ttf" | xargs dirname | sort | uniq | xargs basename -a | sort >dirsfull.txt

cat dirsfull.txt | uniq >dirsnames.txt

diff dirsnames.txt dirsfull.txt | grep '^> '
> nunito
> static
```

```
find * -name "*.ttf" | xargs dirname | sort | uniq | grep -w -e static -e nunito
apache/roboto/static
lang/data/test/nunito
ofl/inconsolata/static
ofl/nunito
```

lang: python module

apache/roboto/static = roboto

ofl/inconsolata/static = inconsolata

## extra folders

### catalog

metadata

### python modules

find . -name "*.py"

```
axisregistry
lang
```

todo: ignore these folders

## filesystem schema

google-fonts/README.md

> The top-level directories indicate the license of all files found within them.
> Subdirectories are named according to the family name of the fonts within.


```
${license}/${fontFamily}/**.ttf
```

## fonts with no ttf files

```
find google-fonts/cc-by-sa/knowledge -name "*.ttf" | wc -l
0
```

TODO use other font formats?

## unique font filenames?

TODO

at least per family, filenames should be unique
