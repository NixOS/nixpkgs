FILES="configure io/ftwtest-sh"
for i in $FILES ; do
  sed  -e "s^@PWD@^pwd^g" < $i > $i.new
  mv $i.new $i
  chmod +x $i
done
