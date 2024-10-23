# Delete the logic of find_ruff_bin
/ruff_exe =/,/if __name__/{
  //!d
}

# Make the exe a static path, and restore the return value
/ruff_exe =/ {
  s/"ruff.*/"@RUFF_BIN@"/
  a
  a \    return ruff_exe
}


# Keep the two empty lines between the lines
/if __name__/ {
  h
  i
  i
}
