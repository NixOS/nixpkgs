function __bb_complete_tasks
  if not test "$__bb_tasks"
    set -g __bb_tasks (bb tasks |tail -n +3 |cut -f1 -d ' ')
  end

  printf "%s\n" $__bb_tasks
end

complete -c bb -a "(__bb_complete_tasks)" -d 'tasks'
