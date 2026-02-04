#!/usr/bin/env bash
export INPUT="$1"
export OUTPUT="$2"
sed 's/_("\(.*\)")/"\1"/g; s/gettext("\(.*\)")/"\1"/g' $INPUT > $OUTPUT
