(function(scope){
'use strict';

function F(arity, fun, wrapper) {
  wrapper.a = arity;
  wrapper.f = fun;
  return wrapper;
}

function F2(fun) {
  return F(2, fun, function(a) { return function(b) { return fun(a,b); }; })
}
function F3(fun) {
  return F(3, fun, function(a) {
    return function(b) { return function(c) { return fun(a, b, c); }; };
  });
}
function F4(fun) {
  return F(4, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return fun(a, b, c, d); }; }; };
  });
}
function F5(fun) {
  return F(5, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return fun(a, b, c, d, e); }; }; }; };
  });
}
function F6(fun) {
  return F(6, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return fun(a, b, c, d, e, f); }; }; }; }; };
  });
}
function F7(fun) {
  return F(7, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return fun(a, b, c, d, e, f, g); }; }; }; }; }; };
  });
}
function F8(fun) {
  return F(8, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) {
    return fun(a, b, c, d, e, f, g, h); }; }; }; }; }; }; };
  });
}
function F9(fun) {
  return F(9, fun, function(a) { return function(b) { return function(c) {
    return function(d) { return function(e) { return function(f) {
    return function(g) { return function(h) { return function(i) {
    return fun(a, b, c, d, e, f, g, h, i); }; }; }; }; }; }; }; };
  });
}

function A2(fun, a, b) {
  return fun.a === 2 ? fun.f(a, b) : fun(a)(b);
}
function A3(fun, a, b, c) {
  return fun.a === 3 ? fun.f(a, b, c) : fun(a)(b)(c);
}
function A4(fun, a, b, c, d) {
  return fun.a === 4 ? fun.f(a, b, c, d) : fun(a)(b)(c)(d);
}
function A5(fun, a, b, c, d, e) {
  return fun.a === 5 ? fun.f(a, b, c, d, e) : fun(a)(b)(c)(d)(e);
}
function A6(fun, a, b, c, d, e, f) {
  return fun.a === 6 ? fun.f(a, b, c, d, e, f) : fun(a)(b)(c)(d)(e)(f);
}
function A7(fun, a, b, c, d, e, f, g) {
  return fun.a === 7 ? fun.f(a, b, c, d, e, f, g) : fun(a)(b)(c)(d)(e)(f)(g);
}
function A8(fun, a, b, c, d, e, f, g, h) {
  return fun.a === 8 ? fun.f(a, b, c, d, e, f, g, h) : fun(a)(b)(c)(d)(e)(f)(g)(h);
}
function A9(fun, a, b, c, d, e, f, g, h, i) {
  return fun.a === 9 ? fun.f(a, b, c, d, e, f, g, h, i) : fun(a)(b)(c)(d)(e)(f)(g)(h)(i);
}




var _List_Nil = { $: 0 };
var _List_Nil_UNUSED = { $: '[]' };

function _List_Cons(hd, tl) { return { $: 1, a: hd, b: tl }; }
function _List_Cons_UNUSED(hd, tl) { return { $: '::', a: hd, b: tl }; }


var _List_cons = F2(_List_Cons);

function _List_fromArray(arr)
{
	var out = _List_Nil;
	for (var i = arr.length; i--; )
	{
		out = _List_Cons(arr[i], out);
	}
	return out;
}

function _List_toArray(xs)
{
	for (var out = []; xs.b; xs = xs.b) // WHILE_CONS
	{
		out.push(xs.a);
	}
	return out;
}

var _List_map2 = F3(function(f, xs, ys)
{
	for (var arr = []; xs.b && ys.b; xs = xs.b, ys = ys.b) // WHILE_CONSES
	{
		arr.push(A2(f, xs.a, ys.a));
	}
	return _List_fromArray(arr);
});

var _List_map3 = F4(function(f, xs, ys, zs)
{
	for (var arr = []; xs.b && ys.b && zs.b; xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A3(f, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map4 = F5(function(f, ws, xs, ys, zs)
{
	for (var arr = []; ws.b && xs.b && ys.b && zs.b; ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A4(f, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_map5 = F6(function(f, vs, ws, xs, ys, zs)
{
	for (var arr = []; vs.b && ws.b && xs.b && ys.b && zs.b; vs = vs.b, ws = ws.b, xs = xs.b, ys = ys.b, zs = zs.b) // WHILE_CONSES
	{
		arr.push(A5(f, vs.a, ws.a, xs.a, ys.a, zs.a));
	}
	return _List_fromArray(arr);
});

var _List_sortBy = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		return _Utils_cmp(f(a), f(b));
	}));
});

var _List_sortWith = F2(function(f, xs)
{
	return _List_fromArray(_List_toArray(xs).sort(function(a, b) {
		var ord = A2(f, a, b);
		return ord === $elm$core$Basics$EQ ? 0 : ord === $elm$core$Basics$LT ? -1 : 1;
	}));
});



var _JsArray_empty = [];

function _JsArray_singleton(value)
{
    return [value];
}

function _JsArray_length(array)
{
    return array.length;
}

var _JsArray_initialize = F3(function(size, offset, func)
{
    var result = new Array(size);

    for (var i = 0; i < size; i++)
    {
        result[i] = func(offset + i);
    }

    return result;
});

var _JsArray_initializeFromList = F2(function (max, ls)
{
    var result = new Array(max);

    for (var i = 0; i < max && ls.b; i++)
    {
        result[i] = ls.a;
        ls = ls.b;
    }

    result.length = i;
    return _Utils_Tuple2(result, ls);
});

var _JsArray_unsafeGet = F2(function(index, array)
{
    return array[index];
});

var _JsArray_unsafeSet = F3(function(index, value, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[index] = value;
    return result;
});

var _JsArray_push = F2(function(value, array)
{
    var length = array.length;
    var result = new Array(length + 1);

    for (var i = 0; i < length; i++)
    {
        result[i] = array[i];
    }

    result[length] = value;
    return result;
});

var _JsArray_foldl = F3(function(func, acc, array)
{
    var length = array.length;

    for (var i = 0; i < length; i++)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_foldr = F3(function(func, acc, array)
{
    for (var i = array.length - 1; i >= 0; i--)
    {
        acc = A2(func, array[i], acc);
    }

    return acc;
});

var _JsArray_map = F2(function(func, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = func(array[i]);
    }

    return result;
});

var _JsArray_indexedMap = F3(function(func, offset, array)
{
    var length = array.length;
    var result = new Array(length);

    for (var i = 0; i < length; i++)
    {
        result[i] = A2(func, offset + i, array[i]);
    }

    return result;
});

var _JsArray_slice = F3(function(from, to, array)
{
    return array.slice(from, to);
});

var _JsArray_appendN = F3(function(n, dest, source)
{
    var destLen = dest.length;
    var itemsToCopy = n - destLen;

    if (itemsToCopy > source.length)
    {
        itemsToCopy = source.length;
    }

    var size = destLen + itemsToCopy;
    var result = new Array(size);

    for (var i = 0; i < destLen; i++)
    {
        result[i] = dest[i];
    }

    for (var i = 0; i < itemsToCopy; i++)
    {
        result[i + destLen] = source[i];
    }

    return result;
});



// LOG

var _Debug_log = F2(function(tag, value)
{
	return value;
});

var _Debug_log_UNUSED = F2(function(tag, value)
{
	console.log(tag + ': ' + _Debug_toString(value));
	return value;
});


// TODOS

function _Debug_todo(moduleName, region)
{
	return function(message) {
		_Debug_crash(8, moduleName, region, message);
	};
}

function _Debug_todoCase(moduleName, region, value)
{
	return function(message) {
		_Debug_crash(9, moduleName, region, value, message);
	};
}


// TO STRING

function _Debug_toString(value)
{
	return '<internals>';
}

function _Debug_toString_UNUSED(value)
{
	return _Debug_toAnsiString(false, value);
}

function _Debug_toAnsiString(ansi, value)
{
	if (typeof value === 'function')
	{
		return _Debug_internalColor(ansi, '<function>');
	}

	if (typeof value === 'boolean')
	{
		return _Debug_ctorColor(ansi, value ? 'True' : 'False');
	}

	if (typeof value === 'number')
	{
		return _Debug_numberColor(ansi, value + '');
	}

	if (value instanceof String)
	{
		return _Debug_charColor(ansi, "'" + _Debug_addSlashes(value, true) + "'");
	}

	if (typeof value === 'string')
	{
		return _Debug_stringColor(ansi, '"' + _Debug_addSlashes(value, false) + '"');
	}

	if (typeof value === 'object' && '$' in value)
	{
		var tag = value.$;

		if (typeof tag === 'number')
		{
			return _Debug_internalColor(ansi, '<internals>');
		}

		if (tag[0] === '#')
		{
			var output = [];
			for (var k in value)
			{
				if (k === '$') continue;
				output.push(_Debug_toAnsiString(ansi, value[k]));
			}
			return '(' + output.join(',') + ')';
		}

		if (tag === 'Set_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Set')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Set$toList(value));
		}

		if (tag === 'RBNode_elm_builtin' || tag === 'RBEmpty_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Dict')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Dict$toList(value));
		}

		if (tag === 'Array_elm_builtin')
		{
			return _Debug_ctorColor(ansi, 'Array')
				+ _Debug_fadeColor(ansi, '.fromList') + ' '
				+ _Debug_toAnsiString(ansi, $elm$core$Array$toList(value));
		}

		if (tag === '::' || tag === '[]')
		{
			var output = '[';

			value.b && (output += _Debug_toAnsiString(ansi, value.a), value = value.b)

			for (; value.b; value = value.b) // WHILE_CONS
			{
				output += ',' + _Debug_toAnsiString(ansi, value.a);
			}
			return output + ']';
		}

		var output = '';
		for (var i in value)
		{
			if (i === '$') continue;
			var str = _Debug_toAnsiString(ansi, value[i]);
			var c0 = str[0];
			var parenless = c0 === '{' || c0 === '(' || c0 === '[' || c0 === '<' || c0 === '"' || str.indexOf(' ') < 0;
			output += ' ' + (parenless ? str : '(' + str + ')');
		}
		return _Debug_ctorColor(ansi, tag) + output;
	}

	if (typeof DataView === 'function' && value instanceof DataView)
	{
		return _Debug_stringColor(ansi, '<' + value.byteLength + ' bytes>');
	}

	if (typeof File !== 'undefined' && value instanceof File)
	{
		return _Debug_internalColor(ansi, '<' + value.name + '>');
	}

	if (typeof value === 'object')
	{
		var output = [];
		for (var key in value)
		{
			var field = key[0] === '_' ? key.slice(1) : key;
			output.push(_Debug_fadeColor(ansi, field) + ' = ' + _Debug_toAnsiString(ansi, value[key]));
		}
		if (output.length === 0)
		{
			return '{}';
		}
		return '{ ' + output.join(', ') + ' }';
	}

	return _Debug_internalColor(ansi, '<internals>');
}

function _Debug_addSlashes(str, isChar)
{
	var s = str
		.replace(/\\/g, '\\\\')
		.replace(/\n/g, '\\n')
		.replace(/\t/g, '\\t')
		.replace(/\r/g, '\\r')
		.replace(/\v/g, '\\v')
		.replace(/\0/g, '\\0');

	if (isChar)
	{
		return s.replace(/\'/g, '\\\'');
	}
	else
	{
		return s.replace(/\"/g, '\\"');
	}
}

function _Debug_ctorColor(ansi, string)
{
	return ansi ? '\x1b[96m' + string + '\x1b[0m' : string;
}

function _Debug_numberColor(ansi, string)
{
	return ansi ? '\x1b[95m' + string + '\x1b[0m' : string;
}

function _Debug_stringColor(ansi, string)
{
	return ansi ? '\x1b[93m' + string + '\x1b[0m' : string;
}

function _Debug_charColor(ansi, string)
{
	return ansi ? '\x1b[92m' + string + '\x1b[0m' : string;
}

function _Debug_fadeColor(ansi, string)
{
	return ansi ? '\x1b[37m' + string + '\x1b[0m' : string;
}

function _Debug_internalColor(ansi, string)
{
	return ansi ? '\x1b[36m' + string + '\x1b[0m' : string;
}

function _Debug_toHexDigit(n)
{
	return String.fromCharCode(n < 10 ? 48 + n : 55 + n);
}


// CRASH


function _Debug_crash(identifier)
{
	throw new Error('https://github.com/elm/core/blob/1.0.0/hints/' + identifier + '.md');
}


function _Debug_crash_UNUSED(identifier, fact1, fact2, fact3, fact4)
{
	switch(identifier)
	{
		case 0:
			throw new Error('What node should I take over? In JavaScript I need something like:\n\n    Elm.Main.init({\n        node: document.getElementById("elm-node")\n    })\n\nYou need to do this with any Browser.sandbox or Browser.element program.');

		case 1:
			throw new Error('Browser.application programs cannot handle URLs like this:\n\n    ' + document.location.href + '\n\nWhat is the root? The root of your file system? Try looking at this program with `elm reactor` or some other server.');

		case 2:
			var jsonErrorString = fact1;
			throw new Error('Problem with the flags given to your Elm program on initialization.\n\n' + jsonErrorString);

		case 3:
			var portName = fact1;
			throw new Error('There can only be one port named `' + portName + '`, but your program has multiple.');

		case 4:
			var portName = fact1;
			var problem = fact2;
			throw new Error('Trying to send an unexpected type of value through port `' + portName + '`:\n' + problem);

		case 5:
			throw new Error('Trying to use `(==)` on functions.\nThere is no way to know if functions are "the same" in the Elm sense.\nRead more about this at https://package.elm-lang.org/packages/elm/core/latest/Basics#== which describes why it is this way and what the better version will look like.');

		case 6:
			var moduleName = fact1;
			throw new Error('Your page is loading multiple Elm scripts with a module named ' + moduleName + '. Maybe a duplicate script is getting loaded accidentally? If not, rename one of them so I know which is which!');

		case 8:
			var moduleName = fact1;
			var region = fact2;
			var message = fact3;
			throw new Error('TODO in module `' + moduleName + '` ' + _Debug_regionToString(region) + '\n\n' + message);

		case 9:
			var moduleName = fact1;
			var region = fact2;
			var value = fact3;
			var message = fact4;
			throw new Error(
				'TODO in module `' + moduleName + '` from the `case` expression '
				+ _Debug_regionToString(region) + '\n\nIt received the following value:\n\n    '
				+ _Debug_toString(value).replace('\n', '\n    ')
				+ '\n\nBut the branch that handles it says:\n\n    ' + message.replace('\n', '\n    ')
			);

		case 10:
			throw new Error('Bug in https://github.com/elm/virtual-dom/issues');

		case 11:
			throw new Error('Cannot perform mod 0. Division by zero error.');
	}
}

function _Debug_regionToString(region)
{
	if (region.z.C === region.w.C)
	{
		return 'on line ' + region.z.C;
	}
	return 'on lines ' + region.z.C + ' through ' + region.w.C;
}



// EQUALITY

function _Utils_eq(x, y)
{
	for (
		var pair, stack = [], isEqual = _Utils_eqHelp(x, y, 0, stack);
		isEqual && (pair = stack.pop());
		isEqual = _Utils_eqHelp(pair.a, pair.b, 0, stack)
		)
	{}

	return isEqual;
}

function _Utils_eqHelp(x, y, depth, stack)
{
	if (x === y)
	{
		return true;
	}

	if (typeof x !== 'object' || x === null || y === null)
	{
		typeof x === 'function' && _Debug_crash(5);
		return false;
	}

	if (depth > 100)
	{
		stack.push(_Utils_Tuple2(x,y));
		return true;
	}

	/**_UNUSED/
	if (x.$ === 'Set_elm_builtin')
	{
		x = $elm$core$Set$toList(x);
		y = $elm$core$Set$toList(y);
	}
	if (x.$ === 'RBNode_elm_builtin' || x.$ === 'RBEmpty_elm_builtin')
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	/**/
	if (x.$ < 0)
	{
		x = $elm$core$Dict$toList(x);
		y = $elm$core$Dict$toList(y);
	}
	//*/

	for (var key in x)
	{
		if (!_Utils_eqHelp(x[key], y[key], depth + 1, stack))
		{
			return false;
		}
	}
	return true;
}

var _Utils_equal = F2(_Utils_eq);
var _Utils_notEqual = F2(function(a, b) { return !_Utils_eq(a,b); });



// COMPARISONS

// Code in Generate/JavaScript.hs, Basics.js, and List.js depends on
// the particular integer values assigned to LT, EQ, and GT.

function _Utils_cmp(x, y, ord)
{
	if (typeof x !== 'object')
	{
		return x === y ? /*EQ*/ 0 : x < y ? /*LT*/ -1 : /*GT*/ 1;
	}

	/**_UNUSED/
	if (x instanceof String)
	{
		var a = x.valueOf();
		var b = y.valueOf();
		return a === b ? 0 : a < b ? -1 : 1;
	}
	//*/

	/**/
	if (typeof x.$ === 'undefined')
	//*/
	/**_UNUSED/
	if (x.$[0] === '#')
	//*/
	{
		return (ord = _Utils_cmp(x.a, y.a))
			? ord
			: (ord = _Utils_cmp(x.b, y.b))
				? ord
				: _Utils_cmp(x.c, y.c);
	}

	// traverse conses until end of a list or a mismatch
	for (; x.b && y.b && !(ord = _Utils_cmp(x.a, y.a)); x = x.b, y = y.b) {} // WHILE_CONSES
	return ord || (x.b ? /*GT*/ 1 : y.b ? /*LT*/ -1 : /*EQ*/ 0);
}

var _Utils_lt = F2(function(a, b) { return _Utils_cmp(a, b) < 0; });
var _Utils_le = F2(function(a, b) { return _Utils_cmp(a, b) < 1; });
var _Utils_gt = F2(function(a, b) { return _Utils_cmp(a, b) > 0; });
var _Utils_ge = F2(function(a, b) { return _Utils_cmp(a, b) >= 0; });

var _Utils_compare = F2(function(x, y)
{
	var n = _Utils_cmp(x, y);
	return n < 0 ? $elm$core$Basics$LT : n ? $elm$core$Basics$GT : $elm$core$Basics$EQ;
});


// COMMON VALUES

var _Utils_Tuple0 = 0;
var _Utils_Tuple0_UNUSED = { $: '#0' };

function _Utils_Tuple2(a, b) { return { a: a, b: b }; }
function _Utils_Tuple2_UNUSED(a, b) { return { $: '#2', a: a, b: b }; }

function _Utils_Tuple3(a, b, c) { return { a: a, b: b, c: c }; }
function _Utils_Tuple3_UNUSED(a, b, c) { return { $: '#3', a: a, b: b, c: c }; }

function _Utils_chr(c) { return c; }
function _Utils_chr_UNUSED(c) { return new String(c); }


// RECORDS

function _Utils_update(oldRecord, updatedFields)
{
	var newRecord = {};

	for (var key in oldRecord)
	{
		newRecord[key] = oldRecord[key];
	}

	for (var key in updatedFields)
	{
		newRecord[key] = updatedFields[key];
	}

	return newRecord;
}


// APPEND

var _Utils_append = F2(_Utils_ap);

function _Utils_ap(xs, ys)
{
	// append Strings
	if (typeof xs === 'string')
	{
		return xs + ys;
	}

	// append Lists
	if (!xs.b)
	{
		return ys;
	}
	var root = _List_Cons(xs.a, ys);
	xs = xs.b
	for (var curr = root; xs.b; xs = xs.b) // WHILE_CONS
	{
		curr = curr.b = _List_Cons(xs.a, ys);
	}
	return root;
}



// MATH

var _Basics_add = F2(function(a, b) { return a + b; });
var _Basics_sub = F2(function(a, b) { return a - b; });
var _Basics_mul = F2(function(a, b) { return a * b; });
var _Basics_fdiv = F2(function(a, b) { return a / b; });
var _Basics_idiv = F2(function(a, b) { return (a / b) | 0; });
var _Basics_pow = F2(Math.pow);

var _Basics_remainderBy = F2(function(b, a) { return a % b; });

// https://www.microsoft.com/en-us/research/wp-content/uploads/2016/02/divmodnote-letter.pdf
var _Basics_modBy = F2(function(modulus, x)
{
	var answer = x % modulus;
	return modulus === 0
		? _Debug_crash(11)
		:
	((answer > 0 && modulus < 0) || (answer < 0 && modulus > 0))
		? answer + modulus
		: answer;
});


// TRIGONOMETRY

var _Basics_pi = Math.PI;
var _Basics_e = Math.E;
var _Basics_cos = Math.cos;
var _Basics_sin = Math.sin;
var _Basics_tan = Math.tan;
var _Basics_acos = Math.acos;
var _Basics_asin = Math.asin;
var _Basics_atan = Math.atan;
var _Basics_atan2 = F2(Math.atan2);


// MORE MATH

function _Basics_toFloat(x) { return x; }
function _Basics_truncate(n) { return n | 0; }
function _Basics_isInfinite(n) { return n === Infinity || n === -Infinity; }

var _Basics_ceiling = Math.ceil;
var _Basics_floor = Math.floor;
var _Basics_round = Math.round;
var _Basics_sqrt = Math.sqrt;
var _Basics_log = Math.log;
var _Basics_isNaN = isNaN;


// BOOLEANS

function _Basics_not(bool) { return !bool; }
var _Basics_and = F2(function(a, b) { return a && b; });
var _Basics_or  = F2(function(a, b) { return a || b; });
var _Basics_xor = F2(function(a, b) { return a !== b; });



var _String_cons = F2(function(chr, str)
{
	return chr + str;
});

function _String_uncons(string)
{
	var word = string.charCodeAt(0);
	return !isNaN(word)
		? $elm$core$Maybe$Just(
			0xD800 <= word && word <= 0xDBFF
				? _Utils_Tuple2(_Utils_chr(string[0] + string[1]), string.slice(2))
				: _Utils_Tuple2(_Utils_chr(string[0]), string.slice(1))
		)
		: $elm$core$Maybe$Nothing;
}

var _String_append = F2(function(a, b)
{
	return a + b;
});

function _String_length(str)
{
	return str.length;
}

var _String_map = F2(function(func, string)
{
	var len = string.length;
	var array = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = string.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			array[i] = func(_Utils_chr(string[i] + string[i+1]));
			i += 2;
			continue;
		}
		array[i] = func(_Utils_chr(string[i]));
		i++;
	}
	return array.join('');
});

var _String_filter = F2(function(isGood, str)
{
	var arr = [];
	var len = str.length;
	var i = 0;
	while (i < len)
	{
		var char = str[i];
		var word = str.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += str[i];
			i++;
		}

		if (isGood(_Utils_chr(char)))
		{
			arr.push(char);
		}
	}
	return arr.join('');
});

function _String_reverse(str)
{
	var len = str.length;
	var arr = new Array(len);
	var i = 0;
	while (i < len)
	{
		var word = str.charCodeAt(i);
		if (0xD800 <= word && word <= 0xDBFF)
		{
			arr[len - i] = str[i + 1];
			i++;
			arr[len - i] = str[i - 1];
			i++;
		}
		else
		{
			arr[len - i] = str[i];
			i++;
		}
	}
	return arr.join('');
}

var _String_foldl = F3(function(func, state, string)
{
	var len = string.length;
	var i = 0;
	while (i < len)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		i++;
		if (0xD800 <= word && word <= 0xDBFF)
		{
			char += string[i];
			i++;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_foldr = F3(function(func, state, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		state = A2(func, _Utils_chr(char), state);
	}
	return state;
});

var _String_split = F2(function(sep, str)
{
	return str.split(sep);
});

var _String_join = F2(function(sep, strs)
{
	return strs.join(sep);
});

var _String_slice = F3(function(start, end, str) {
	return str.slice(start, end);
});

function _String_trim(str)
{
	return str.trim();
}

function _String_trimLeft(str)
{
	return str.replace(/^\s+/, '');
}

function _String_trimRight(str)
{
	return str.replace(/\s+$/, '');
}

function _String_words(str)
{
	return _List_fromArray(str.trim().split(/\s+/g));
}

function _String_lines(str)
{
	return _List_fromArray(str.split(/\r\n|\r|\n/g));
}

function _String_toUpper(str)
{
	return str.toUpperCase();
}

function _String_toLower(str)
{
	return str.toLowerCase();
}

var _String_any = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (isGood(_Utils_chr(char)))
		{
			return true;
		}
	}
	return false;
});

var _String_all = F2(function(isGood, string)
{
	var i = string.length;
	while (i--)
	{
		var char = string[i];
		var word = string.charCodeAt(i);
		if (0xDC00 <= word && word <= 0xDFFF)
		{
			i--;
			char = string[i] + char;
		}
		if (!isGood(_Utils_chr(char)))
		{
			return false;
		}
	}
	return true;
});

var _String_contains = F2(function(sub, str)
{
	return str.indexOf(sub) > -1;
});

var _String_startsWith = F2(function(sub, str)
{
	return str.indexOf(sub) === 0;
});

var _String_endsWith = F2(function(sub, str)
{
	return str.length >= sub.length &&
		str.lastIndexOf(sub) === str.length - sub.length;
});

var _String_indexes = F2(function(sub, str)
{
	var subLen = sub.length;

	if (subLen < 1)
	{
		return _List_Nil;
	}

	var i = 0;
	var is = [];

	while ((i = str.indexOf(sub, i)) > -1)
	{
		is.push(i);
		i = i + subLen;
	}

	return _List_fromArray(is);
});


// TO STRING

function _String_fromNumber(number)
{
	return number + '';
}


// INT CONVERSIONS

function _String_toInt(str)
{
	var total = 0;
	var code0 = str.charCodeAt(0);
	var start = code0 == 0x2B /* + */ || code0 == 0x2D /* - */ ? 1 : 0;

	for (var i = start; i < str.length; ++i)
	{
		var code = str.charCodeAt(i);
		if (code < 0x30 || 0x39 < code)
		{
			return $elm$core$Maybe$Nothing;
		}
		total = 10 * total + code - 0x30;
	}

	return i == start
		? $elm$core$Maybe$Nothing
		: $elm$core$Maybe$Just(code0 == 0x2D ? -total : total);
}


// FLOAT CONVERSIONS

function _String_toFloat(s)
{
	// check if it is a hex, octal, or binary number
	if (s.length === 0 || /[\sxbo]/.test(s))
	{
		return $elm$core$Maybe$Nothing;
	}
	var n = +s;
	// faster isNaN check
	return n === n ? $elm$core$Maybe$Just(n) : $elm$core$Maybe$Nothing;
}

function _String_fromList(chars)
{
	return _List_toArray(chars).join('');
}




function _Char_toCode(char)
{
	var code = char.charCodeAt(0);
	if (0xD800 <= code && code <= 0xDBFF)
	{
		return (code - 0xD800) * 0x400 + char.charCodeAt(1) - 0xDC00 + 0x10000
	}
	return code;
}

function _Char_fromCode(code)
{
	return _Utils_chr(
		(code < 0 || 0x10FFFF < code)
			? '\uFFFD'
			:
		(code <= 0xFFFF)
			? String.fromCharCode(code)
			:
		(code -= 0x10000,
			String.fromCharCode(Math.floor(code / 0x400) + 0xD800, code % 0x400 + 0xDC00)
		)
	);
}

function _Char_toUpper(char)
{
	return _Utils_chr(char.toUpperCase());
}

function _Char_toLower(char)
{
	return _Utils_chr(char.toLowerCase());
}

function _Char_toLocaleUpper(char)
{
	return _Utils_chr(char.toLocaleUpperCase());
}

function _Char_toLocaleLower(char)
{
	return _Utils_chr(char.toLocaleLowerCase());
}



/**_UNUSED/
function _Json_errorToString(error)
{
	return $elm$json$Json$Decode$errorToString(error);
}
//*/


// CORE DECODERS

function _Json_succeed(msg)
{
	return {
		$: 0,
		a: msg
	};
}

function _Json_fail(msg)
{
	return {
		$: 1,
		a: msg
	};
}

function _Json_decodePrim(decoder)
{
	return { $: 2, b: decoder };
}

var _Json_decodeInt = _Json_decodePrim(function(value) {
	return (typeof value !== 'number')
		? _Json_expecting('an INT', value)
		:
	(-2147483647 < value && value < 2147483647 && (value | 0) === value)
		? $elm$core$Result$Ok(value)
		:
	(isFinite(value) && !(value % 1))
		? $elm$core$Result$Ok(value)
		: _Json_expecting('an INT', value);
});

var _Json_decodeBool = _Json_decodePrim(function(value) {
	return (typeof value === 'boolean')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a BOOL', value);
});

var _Json_decodeFloat = _Json_decodePrim(function(value) {
	return (typeof value === 'number')
		? $elm$core$Result$Ok(value)
		: _Json_expecting('a FLOAT', value);
});

var _Json_decodeValue = _Json_decodePrim(function(value) {
	return $elm$core$Result$Ok(_Json_wrap(value));
});

var _Json_decodeString = _Json_decodePrim(function(value) {
	return (typeof value === 'string')
		? $elm$core$Result$Ok(value)
		: (value instanceof String)
			? $elm$core$Result$Ok(value + '')
			: _Json_expecting('a STRING', value);
});

function _Json_decodeList(decoder) { return { $: 3, b: decoder }; }
function _Json_decodeArray(decoder) { return { $: 4, b: decoder }; }

function _Json_decodeNull(value) { return { $: 5, c: value }; }

var _Json_decodeField = F2(function(field, decoder)
{
	return {
		$: 6,
		d: field,
		b: decoder
	};
});

var _Json_decodeIndex = F2(function(index, decoder)
{
	return {
		$: 7,
		e: index,
		b: decoder
	};
});

function _Json_decodeKeyValuePairs(decoder)
{
	return {
		$: 8,
		b: decoder
	};
}

function _Json_mapMany(f, decoders)
{
	return {
		$: 9,
		f: f,
		g: decoders
	};
}

var _Json_andThen = F2(function(callback, decoder)
{
	return {
		$: 10,
		b: decoder,
		h: callback
	};
});

function _Json_oneOf(decoders)
{
	return {
		$: 11,
		g: decoders
	};
}


// DECODING OBJECTS

var _Json_map1 = F2(function(f, d1)
{
	return _Json_mapMany(f, [d1]);
});

var _Json_map2 = F3(function(f, d1, d2)
{
	return _Json_mapMany(f, [d1, d2]);
});

var _Json_map3 = F4(function(f, d1, d2, d3)
{
	return _Json_mapMany(f, [d1, d2, d3]);
});

var _Json_map4 = F5(function(f, d1, d2, d3, d4)
{
	return _Json_mapMany(f, [d1, d2, d3, d4]);
});

var _Json_map5 = F6(function(f, d1, d2, d3, d4, d5)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5]);
});

var _Json_map6 = F7(function(f, d1, d2, d3, d4, d5, d6)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6]);
});

var _Json_map7 = F8(function(f, d1, d2, d3, d4, d5, d6, d7)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7]);
});

var _Json_map8 = F9(function(f, d1, d2, d3, d4, d5, d6, d7, d8)
{
	return _Json_mapMany(f, [d1, d2, d3, d4, d5, d6, d7, d8]);
});


// DECODE

var _Json_runOnString = F2(function(decoder, string)
{
	try
	{
		var value = JSON.parse(string);
		return _Json_runHelp(decoder, value);
	}
	catch (e)
	{
		return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'This is not valid JSON! ' + e.message, _Json_wrap(string)));
	}
});

var _Json_run = F2(function(decoder, value)
{
	return _Json_runHelp(decoder, _Json_unwrap(value));
});

function _Json_runHelp(decoder, value)
{
	switch (decoder.$)
	{
		case 2:
			return decoder.b(value);

		case 5:
			return (value === null)
				? $elm$core$Result$Ok(decoder.c)
				: _Json_expecting('null', value);

		case 3:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('a LIST', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _List_fromArray);

		case 4:
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			return _Json_runArrayDecoder(decoder.b, value, _Json_toElmArray);

		case 6:
			var field = decoder.d;
			if (typeof value !== 'object' || value === null || !(field in value))
			{
				return _Json_expecting('an OBJECT with a field named `' + field + '`', value);
			}
			var result = _Json_runHelp(decoder.b, value[field]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, field, result.a));

		case 7:
			var index = decoder.e;
			if (!_Json_isArray(value))
			{
				return _Json_expecting('an ARRAY', value);
			}
			if (index >= value.length)
			{
				return _Json_expecting('a LONGER array. Need index ' + index + ' but only see ' + value.length + ' entries', value);
			}
			var result = _Json_runHelp(decoder.b, value[index]);
			return ($elm$core$Result$isOk(result)) ? result : $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, index, result.a));

		case 8:
			if (typeof value !== 'object' || value === null || _Json_isArray(value))
			{
				return _Json_expecting('an OBJECT', value);
			}

			var keyValuePairs = _List_Nil;
			// TODO test perf of Object.keys and switch when support is good enough
			for (var key in value)
			{
				if (Object.prototype.hasOwnProperty.call(value, key))
				{
					var result = _Json_runHelp(decoder.b, value[key]);
					if (!$elm$core$Result$isOk(result))
					{
						return $elm$core$Result$Err(A2($elm$json$Json$Decode$Field, key, result.a));
					}
					keyValuePairs = _List_Cons(_Utils_Tuple2(key, result.a), keyValuePairs);
				}
			}
			return $elm$core$Result$Ok($elm$core$List$reverse(keyValuePairs));

		case 9:
			var answer = decoder.f;
			var decoders = decoder.g;
			for (var i = 0; i < decoders.length; i++)
			{
				var result = _Json_runHelp(decoders[i], value);
				if (!$elm$core$Result$isOk(result))
				{
					return result;
				}
				answer = answer(result.a);
			}
			return $elm$core$Result$Ok(answer);

		case 10:
			var result = _Json_runHelp(decoder.b, value);
			return (!$elm$core$Result$isOk(result))
				? result
				: _Json_runHelp(decoder.h(result.a), value);

		case 11:
			var errors = _List_Nil;
			for (var temp = decoder.g; temp.b; temp = temp.b) // WHILE_CONS
			{
				var result = _Json_runHelp(temp.a, value);
				if ($elm$core$Result$isOk(result))
				{
					return result;
				}
				errors = _List_Cons(result.a, errors);
			}
			return $elm$core$Result$Err($elm$json$Json$Decode$OneOf($elm$core$List$reverse(errors)));

		case 1:
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, decoder.a, _Json_wrap(value)));

		case 0:
			return $elm$core$Result$Ok(decoder.a);
	}
}

function _Json_runArrayDecoder(decoder, value, toElmValue)
{
	var len = value.length;
	var array = new Array(len);
	for (var i = 0; i < len; i++)
	{
		var result = _Json_runHelp(decoder, value[i]);
		if (!$elm$core$Result$isOk(result))
		{
			return $elm$core$Result$Err(A2($elm$json$Json$Decode$Index, i, result.a));
		}
		array[i] = result.a;
	}
	return $elm$core$Result$Ok(toElmValue(array));
}

function _Json_isArray(value)
{
	return Array.isArray(value) || (typeof FileList !== 'undefined' && value instanceof FileList);
}

function _Json_toElmArray(array)
{
	return A2($elm$core$Array$initialize, array.length, function(i) { return array[i]; });
}

function _Json_expecting(type, value)
{
	return $elm$core$Result$Err(A2($elm$json$Json$Decode$Failure, 'Expecting ' + type, _Json_wrap(value)));
}


// EQUALITY

function _Json_equality(x, y)
{
	if (x === y)
	{
		return true;
	}

	if (x.$ !== y.$)
	{
		return false;
	}

	switch (x.$)
	{
		case 0:
		case 1:
			return x.a === y.a;

		case 2:
			return x.b === y.b;

		case 5:
			return x.c === y.c;

		case 3:
		case 4:
		case 8:
			return _Json_equality(x.b, y.b);

		case 6:
			return x.d === y.d && _Json_equality(x.b, y.b);

		case 7:
			return x.e === y.e && _Json_equality(x.b, y.b);

		case 9:
			return x.f === y.f && _Json_listEquality(x.g, y.g);

		case 10:
			return x.h === y.h && _Json_equality(x.b, y.b);

		case 11:
			return _Json_listEquality(x.g, y.g);
	}
}

function _Json_listEquality(aDecoders, bDecoders)
{
	var len = aDecoders.length;
	if (len !== bDecoders.length)
	{
		return false;
	}
	for (var i = 0; i < len; i++)
	{
		if (!_Json_equality(aDecoders[i], bDecoders[i]))
		{
			return false;
		}
	}
	return true;
}


// ENCODE

var _Json_encode = F2(function(indentLevel, value)
{
	return JSON.stringify(_Json_unwrap(value), null, indentLevel) + '';
});

function _Json_wrap_UNUSED(value) { return { $: 0, a: value }; }
function _Json_unwrap_UNUSED(value) { return value.a; }

function _Json_wrap(value) { return value; }
function _Json_unwrap(value) { return value; }

function _Json_emptyArray() { return []; }
function _Json_emptyObject() { return {}; }

var _Json_addField = F3(function(key, value, object)
{
	var unwrapped = _Json_unwrap(value);
	if (!(key === 'toJSON' && typeof unwrapped === 'function'))
	{
		object[key] = unwrapped;
	}
	return object;
});

function _Json_addEntry(func)
{
	return F2(function(entry, array)
	{
		array.push(_Json_unwrap(func(entry)));
		return array;
	});
}

var _Json_encodeNull = _Json_wrap(null);



// TASKS

function _Scheduler_succeed(value)
{
	return {
		$: 0,
		a: value
	};
}

function _Scheduler_fail(error)
{
	return {
		$: 1,
		a: error
	};
}

function _Scheduler_binding(callback)
{
	return {
		$: 2,
		b: callback,
		c: null
	};
}

var _Scheduler_andThen = F2(function(callback, task)
{
	return {
		$: 3,
		b: callback,
		d: task
	};
});

var _Scheduler_onError = F2(function(callback, task)
{
	return {
		$: 4,
		b: callback,
		d: task
	};
});

function _Scheduler_receive(callback)
{
	return {
		$: 5,
		b: callback
	};
}


// PROCESSES

var _Scheduler_guid = 0;

function _Scheduler_rawSpawn(task)
{
	var proc = {
		$: 0,
		e: _Scheduler_guid++,
		f: task,
		g: null,
		h: []
	};

	_Scheduler_enqueue(proc);

	return proc;
}

function _Scheduler_spawn(task)
{
	return _Scheduler_binding(function(callback) {
		callback(_Scheduler_succeed(_Scheduler_rawSpawn(task)));
	});
}

function _Scheduler_rawSend(proc, msg)
{
	proc.h.push(msg);
	_Scheduler_enqueue(proc);
}

var _Scheduler_send = F2(function(proc, msg)
{
	return _Scheduler_binding(function(callback) {
		_Scheduler_rawSend(proc, msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});

function _Scheduler_kill(proc)
{
	return _Scheduler_binding(function(callback) {
		var task = proc.f;
		if (task.$ === 2 && task.c)
		{
			task.c();
		}

		proc.f = null;

		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
}


/* STEP PROCESSES

type alias Process =
  { $ : tag
  , id : unique_id
  , root : Task
  , stack : null | { $: SUCCEED | FAIL, a: callback, b: stack }
  , mailbox : [msg]
  }

*/


var _Scheduler_working = false;
var _Scheduler_queue = [];


function _Scheduler_enqueue(proc)
{
	_Scheduler_queue.push(proc);
	if (_Scheduler_working)
	{
		return;
	}
	_Scheduler_working = true;
	while (proc = _Scheduler_queue.shift())
	{
		_Scheduler_step(proc);
	}
	_Scheduler_working = false;
}


function _Scheduler_step(proc)
{
	while (proc.f)
	{
		var rootTag = proc.f.$;
		if (rootTag === 0 || rootTag === 1)
		{
			while (proc.g && proc.g.$ !== rootTag)
			{
				proc.g = proc.g.i;
			}
			if (!proc.g)
			{
				return;
			}
			proc.f = proc.g.b(proc.f.a);
			proc.g = proc.g.i;
		}
		else if (rootTag === 2)
		{
			proc.f.c = proc.f.b(function(newRoot) {
				proc.f = newRoot;
				_Scheduler_enqueue(proc);
			});
			return;
		}
		else if (rootTag === 5)
		{
			if (proc.h.length === 0)
			{
				return;
			}
			proc.f = proc.f.b(proc.h.shift());
		}
		else // if (rootTag === 3 || rootTag === 4)
		{
			proc.g = {
				$: rootTag === 3 ? 0 : 1,
				b: proc.f.b,
				i: proc.g
			};
			proc.f = proc.f.d;
		}
	}
}



function _Process_sleep(time)
{
	return _Scheduler_binding(function(callback) {
		var id = setTimeout(function() {
			callback(_Scheduler_succeed(_Utils_Tuple0));
		}, time);

		return function() { clearTimeout(id); };
	});
}




// PROGRAMS


var _Platform_worker = F4(function(impl, flagDecoder, debugMetadata, args)
{
	return _Platform_initialize(
		flagDecoder,
		args,
		impl.at,
		impl.aB,
		impl.aA,
		function() { return function() {} }
	);
});



// INITIALIZE A PROGRAM


function _Platform_initialize(flagDecoder, args, init, update, subscriptions, stepperBuilder)
{
	var result = A2(_Json_run, flagDecoder, _Json_wrap(args ? args['flags'] : undefined));
	$elm$core$Result$isOk(result) || _Debug_crash(2 /**_UNUSED/, _Json_errorToString(result.a) /**/);
	var managers = {};
	var initPair = init(result.a);
	var model = initPair.a;
	var stepper = stepperBuilder(sendToApp, model);
	var ports = _Platform_setupEffects(managers, sendToApp);

	function sendToApp(msg, viewMetadata)
	{
		var pair = A2(update, msg, model);
		stepper(model = pair.a, viewMetadata);
		_Platform_enqueueEffects(managers, pair.b, subscriptions(model));
	}

	_Platform_enqueueEffects(managers, initPair.b, subscriptions(model));

	return ports ? { ports: ports } : {};
}



// TRACK PRELOADS
//
// This is used by code in elm/browser and elm/http
// to register any HTTP requests that are triggered by init.
//


var _Platform_preload;


function _Platform_registerPreload(url)
{
	_Platform_preload.add(url);
}



// EFFECT MANAGERS


var _Platform_effectManagers = {};


function _Platform_setupEffects(managers, sendToApp)
{
	var ports;

	// setup all necessary effect managers
	for (var key in _Platform_effectManagers)
	{
		var manager = _Platform_effectManagers[key];

		if (manager.a)
		{
			ports = ports || {};
			ports[key] = manager.a(key, sendToApp);
		}

		managers[key] = _Platform_instantiateManager(manager, sendToApp);
	}

	return ports;
}


function _Platform_createManager(init, onEffects, onSelfMsg, cmdMap, subMap)
{
	return {
		b: init,
		c: onEffects,
		d: onSelfMsg,
		e: cmdMap,
		f: subMap
	};
}


function _Platform_instantiateManager(info, sendToApp)
{
	var router = {
		g: sendToApp,
		h: undefined
	};

	var onEffects = info.c;
	var onSelfMsg = info.d;
	var cmdMap = info.e;
	var subMap = info.f;

	function loop(state)
	{
		return A2(_Scheduler_andThen, loop, _Scheduler_receive(function(msg)
		{
			var value = msg.a;

			if (msg.$ === 0)
			{
				return A3(onSelfMsg, router, value, state);
			}

			return cmdMap && subMap
				? A4(onEffects, router, value.i, value.j, state)
				: A3(onEffects, router, cmdMap ? value.i : value.j, state);
		}));
	}

	return router.h = _Scheduler_rawSpawn(A2(_Scheduler_andThen, loop, info.b));
}



// ROUTING


var _Platform_sendToApp = F2(function(router, msg)
{
	return _Scheduler_binding(function(callback)
	{
		router.g(msg);
		callback(_Scheduler_succeed(_Utils_Tuple0));
	});
});


var _Platform_sendToSelf = F2(function(router, msg)
{
	return A2(_Scheduler_send, router.h, {
		$: 0,
		a: msg
	});
});



// BAGS


function _Platform_leaf(home)
{
	return function(value)
	{
		return {
			$: 1,
			k: home,
			l: value
		};
	};
}


function _Platform_batch(list)
{
	return {
		$: 2,
		m: list
	};
}


var _Platform_map = F2(function(tagger, bag)
{
	return {
		$: 3,
		n: tagger,
		o: bag
	}
});



// PIPE BAGS INTO EFFECT MANAGERS
//
// Effects must be queued!
//
// Say your init contains a synchronous command, like Time.now or Time.here
//
//   - This will produce a batch of effects (FX_1)
//   - The synchronous task triggers the subsequent `update` call
//   - This will produce a batch of effects (FX_2)
//
// If we just start dispatching FX_2, subscriptions from FX_2 can be processed
// before subscriptions from FX_1. No good! Earlier versions of this code had
// this problem, leading to these reports:
//
//   https://github.com/elm/core/issues/980
//   https://github.com/elm/core/pull/981
//   https://github.com/elm/compiler/issues/1776
//
// The queue is necessary to avoid ordering issues for synchronous commands.


// Why use true/false here? Why not just check the length of the queue?
// The goal is to detect "are we currently dispatching effects?" If we
// are, we need to bail and let the ongoing while loop handle things.
//
// Now say the queue has 1 element. When we dequeue the final element,
// the queue will be empty, but we are still actively dispatching effects.
// So you could get queue jumping in a really tricky category of cases.
//
var _Platform_effectsQueue = [];
var _Platform_effectsActive = false;


function _Platform_enqueueEffects(managers, cmdBag, subBag)
{
	_Platform_effectsQueue.push({ p: managers, q: cmdBag, r: subBag });

	if (_Platform_effectsActive) return;

	_Platform_effectsActive = true;
	for (var fx; fx = _Platform_effectsQueue.shift(); )
	{
		_Platform_dispatchEffects(fx.p, fx.q, fx.r);
	}
	_Platform_effectsActive = false;
}


function _Platform_dispatchEffects(managers, cmdBag, subBag)
{
	var effectsDict = {};
	_Platform_gatherEffects(true, cmdBag, effectsDict, null);
	_Platform_gatherEffects(false, subBag, effectsDict, null);

	for (var home in managers)
	{
		_Scheduler_rawSend(managers[home], {
			$: 'fx',
			a: effectsDict[home] || { i: _List_Nil, j: _List_Nil }
		});
	}
}


function _Platform_gatherEffects(isCmd, bag, effectsDict, taggers)
{
	switch (bag.$)
	{
		case 1:
			var home = bag.k;
			var effect = _Platform_toEffect(isCmd, home, taggers, bag.l);
			effectsDict[home] = _Platform_insert(isCmd, effect, effectsDict[home]);
			return;

		case 2:
			for (var list = bag.m; list.b; list = list.b) // WHILE_CONS
			{
				_Platform_gatherEffects(isCmd, list.a, effectsDict, taggers);
			}
			return;

		case 3:
			_Platform_gatherEffects(isCmd, bag.o, effectsDict, {
				s: bag.n,
				t: taggers
			});
			return;
	}
}


function _Platform_toEffect(isCmd, home, taggers, value)
{
	function applyTaggers(x)
	{
		for (var temp = taggers; temp; temp = temp.t)
		{
			x = temp.s(x);
		}
		return x;
	}

	var map = isCmd
		? _Platform_effectManagers[home].e
		: _Platform_effectManagers[home].f;

	return A2(map, applyTaggers, value)
}


function _Platform_insert(isCmd, newEffect, effects)
{
	effects = effects || { i: _List_Nil, j: _List_Nil };

	isCmd
		? (effects.i = _List_Cons(newEffect, effects.i))
		: (effects.j = _List_Cons(newEffect, effects.j));

	return effects;
}



// PORTS


function _Platform_checkPortName(name)
{
	if (_Platform_effectManagers[name])
	{
		_Debug_crash(3, name)
	}
}



// OUTGOING PORTS


function _Platform_outgoingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		e: _Platform_outgoingPortMap,
		u: converter,
		a: _Platform_setupOutgoingPort
	};
	return _Platform_leaf(name);
}


var _Platform_outgoingPortMap = F2(function(tagger, value) { return value; });


function _Platform_setupOutgoingPort(name)
{
	var subs = [];
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Process_sleep(0);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, cmdList, state)
	{
		for ( ; cmdList.b; cmdList = cmdList.b) // WHILE_CONS
		{
			// grab a separate reference to subs in case unsubscribe is called
			var currentSubs = subs;
			var value = _Json_unwrap(converter(cmdList.a));
			for (var i = 0; i < currentSubs.length; i++)
			{
				currentSubs[i](value);
			}
		}
		return init;
	});

	// PUBLIC API

	function subscribe(callback)
	{
		subs.push(callback);
	}

	function unsubscribe(callback)
	{
		// copy subs into a new array in case unsubscribe is called within a
		// subscribed callback
		subs = subs.slice();
		var index = subs.indexOf(callback);
		if (index >= 0)
		{
			subs.splice(index, 1);
		}
	}

	return {
		subscribe: subscribe,
		unsubscribe: unsubscribe
	};
}



// INCOMING PORTS


function _Platform_incomingPort(name, converter)
{
	_Platform_checkPortName(name);
	_Platform_effectManagers[name] = {
		f: _Platform_incomingPortMap,
		u: converter,
		a: _Platform_setupIncomingPort
	};
	return _Platform_leaf(name);
}


var _Platform_incomingPortMap = F2(function(tagger, finalTagger)
{
	return function(value)
	{
		return tagger(finalTagger(value));
	};
});


function _Platform_setupIncomingPort(name, sendToApp)
{
	var subs = _List_Nil;
	var converter = _Platform_effectManagers[name].u;

	// CREATE MANAGER

	var init = _Scheduler_succeed(null);

	_Platform_effectManagers[name].b = init;
	_Platform_effectManagers[name].c = F3(function(router, subList, state)
	{
		subs = subList;
		return init;
	});

	// PUBLIC API

	function send(incomingValue)
	{
		var result = A2(_Json_run, converter, _Json_wrap(incomingValue));

		$elm$core$Result$isOk(result) || _Debug_crash(4, name, result.a);

		var value = result.a;
		for (var temp = subs; temp.b; temp = temp.b) // WHILE_CONS
		{
			sendToApp(temp.a(value));
		}
	}

	return { send: send };
}



// EXPORT ELM MODULES
//
// Have DEBUG and PROD versions so that we can (1) give nicer errors in
// debug mode and (2) not pay for the bits needed for that in prod mode.
//


function _Platform_export(exports)
{
	scope['Elm']
		? _Platform_mergeExportsProd(scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsProd(obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6)
				: _Platform_mergeExportsProd(obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}


function _Platform_export_UNUSED(exports)
{
	scope['Elm']
		? _Platform_mergeExportsDebug('Elm', scope['Elm'], exports)
		: scope['Elm'] = exports;
}


function _Platform_mergeExportsDebug(moduleName, obj, exports)
{
	for (var name in exports)
	{
		(name in obj)
			? (name == 'init')
				? _Debug_crash(6, moduleName)
				: _Platform_mergeExportsDebug(moduleName + '.' + name, obj[name], exports[name])
			: (obj[name] = exports[name]);
	}
}
var $elm$core$Basics$EQ = 1;
var $elm$core$Basics$LT = 0;
var $elm$core$List$cons = _List_cons;
var $elm$core$Elm$JsArray$foldr = _JsArray_foldr;
var $elm$core$Array$foldr = F3(
	function (func, baseCase, _v0) {
		var tree = _v0.c;
		var tail = _v0.d;
		var helper = F2(
			function (node, acc) {
				if (!node.$) {
					var subTree = node.a;
					return A3($elm$core$Elm$JsArray$foldr, helper, acc, subTree);
				} else {
					var values = node.a;
					return A3($elm$core$Elm$JsArray$foldr, func, acc, values);
				}
			});
		return A3(
			$elm$core$Elm$JsArray$foldr,
			helper,
			A3($elm$core$Elm$JsArray$foldr, func, baseCase, tail),
			tree);
	});
var $elm$core$Array$toList = function (array) {
	return A3($elm$core$Array$foldr, $elm$core$List$cons, _List_Nil, array);
};
var $elm$core$Dict$foldr = F3(
	function (func, acc, t) {
		foldr:
		while (true) {
			if (t.$ === -2) {
				return acc;
			} else {
				var key = t.b;
				var value = t.c;
				var left = t.d;
				var right = t.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldr, func, acc, right)),
					$temp$t = left;
				func = $temp$func;
				acc = $temp$acc;
				t = $temp$t;
				continue foldr;
			}
		}
	});
var $elm$core$Dict$toList = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, list) {
				return A2(
					$elm$core$List$cons,
					_Utils_Tuple2(key, value),
					list);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Dict$keys = function (dict) {
	return A3(
		$elm$core$Dict$foldr,
		F3(
			function (key, value, keyList) {
				return A2($elm$core$List$cons, key, keyList);
			}),
		_List_Nil,
		dict);
};
var $elm$core$Set$toList = function (_v0) {
	var dict = _v0;
	return $elm$core$Dict$keys(dict);
};
var $elm$core$Basics$GT = 2;
var $elm$core$Basics$always = F2(
	function (a, _v0) {
		return a;
	});
var $elm$core$Result$Err = function (a) {
	return {$: 1, a: a};
};
var $elm$json$Json$Decode$Failure = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $elm$json$Json$Decode$Field = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $elm$json$Json$Decode$Index = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $elm$core$Result$Ok = function (a) {
	return {$: 0, a: a};
};
var $elm$json$Json$Decode$OneOf = function (a) {
	return {$: 2, a: a};
};
var $elm$core$Basics$False = 1;
var $elm$core$Basics$add = _Basics_add;
var $elm$core$Maybe$Just = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Maybe$Nothing = {$: 1};
var $elm$core$String$all = _String_all;
var $elm$core$Basics$and = _Basics_and;
var $elm$core$Basics$append = _Utils_append;
var $elm$json$Json$Encode$encode = _Json_encode;
var $elm$core$String$fromInt = _String_fromNumber;
var $elm$core$String$join = F2(
	function (sep, chunks) {
		return A2(
			_String_join,
			sep,
			_List_toArray(chunks));
	});
var $elm$core$String$split = F2(
	function (sep, string) {
		return _List_fromArray(
			A2(_String_split, sep, string));
	});
var $elm$json$Json$Decode$indent = function (str) {
	return A2(
		$elm$core$String$join,
		'\n    ',
		A2($elm$core$String$split, '\n', str));
};
var $elm$core$List$foldl = F3(
	function (func, acc, list) {
		foldl:
		while (true) {
			if (!list.b) {
				return acc;
			} else {
				var x = list.a;
				var xs = list.b;
				var $temp$func = func,
					$temp$acc = A2(func, x, acc),
					$temp$list = xs;
				func = $temp$func;
				acc = $temp$acc;
				list = $temp$list;
				continue foldl;
			}
		}
	});
var $elm$core$List$length = function (xs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, i) {
				return i + 1;
			}),
		0,
		xs);
};
var $elm$core$List$map2 = _List_map2;
var $elm$core$Basics$le = _Utils_le;
var $elm$core$Basics$sub = _Basics_sub;
var $elm$core$List$rangeHelp = F3(
	function (lo, hi, list) {
		rangeHelp:
		while (true) {
			if (_Utils_cmp(lo, hi) < 1) {
				var $temp$lo = lo,
					$temp$hi = hi - 1,
					$temp$list = A2($elm$core$List$cons, hi, list);
				lo = $temp$lo;
				hi = $temp$hi;
				list = $temp$list;
				continue rangeHelp;
			} else {
				return list;
			}
		}
	});
var $elm$core$List$range = F2(
	function (lo, hi) {
		return A3($elm$core$List$rangeHelp, lo, hi, _List_Nil);
	});
var $elm$core$List$indexedMap = F2(function (f, xs) {
  var tmp = _List_Cons(undefined, _List_Nil);
  var end = tmp;
  for (var i = 0; xs.b; i++, xs = xs.b) {
    var next = _List_Cons(A2(f, i, xs.a), _List_Nil);
    end.b = next;
    end = next;
  }
  return tmp.b;
});
var $elm$core$Char$toCode = _Char_toCode;
var $elm$core$Char$isLower = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (97 <= code) && (code <= 122);
};
var $elm$core$Char$isUpper = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$or = _Basics_or;
var $elm$core$Char$isAlpha = function (_char) {
	return $elm$core$Char$isLower(_char) || $elm$core$Char$isUpper(_char);
};
var $elm$core$Char$isDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return (code <= 57) && (48 <= code);
};
var $elm$core$Char$isAlphaNum = function (_char) {
	return $elm$core$Char$isLower(_char) || ($elm$core$Char$isUpper(_char) || $elm$core$Char$isDigit(_char));
};
var $elm$core$List$reverse = function (list) {
	return A3($elm$core$List$foldl, $elm$core$List$cons, _List_Nil, list);
};
var $elm$core$String$uncons = _String_uncons;
var $elm$json$Json$Decode$errorOneOf = F2(
	function (i, error) {
		return '\n\n(' + ($elm$core$String$fromInt(i + 1) + (') ' + $elm$json$Json$Decode$indent(
			$elm$json$Json$Decode$errorToString(error))));
	});
var $elm$json$Json$Decode$errorToString = function (error) {
	return A2($elm$json$Json$Decode$errorToStringHelp, error, _List_Nil);
};
var $elm$json$Json$Decode$errorToStringHelp = F2(
	function (error, context) {
		errorToStringHelp:
		while (true) {
			switch (error.$) {
				case 0:
					var f = error.a;
					var err = error.b;
					var isSimple = function () {
						var _v1 = $elm$core$String$uncons(f);
						if (_v1.$ === 1) {
							return false;
						} else {
							var _v2 = _v1.a;
							var _char = _v2.a;
							var rest = _v2.b;
							return $elm$core$Char$isAlpha(_char) && A2($elm$core$String$all, $elm$core$Char$isAlphaNum, rest);
						}
					}();
					var fieldName = isSimple ? ('.' + f) : ('[\'' + (f + '\']'));
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, fieldName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 1:
					var i = error.a;
					var err = error.b;
					var indexName = '[' + ($elm$core$String$fromInt(i) + ']');
					var $temp$error = err,
						$temp$context = A2($elm$core$List$cons, indexName, context);
					error = $temp$error;
					context = $temp$context;
					continue errorToStringHelp;
				case 2:
					var errors = error.a;
					if (!errors.b) {
						return 'Ran into a Json.Decode.oneOf with no possibilities' + function () {
							if (!context.b) {
								return '!';
							} else {
								return ' at json' + A2(
									$elm$core$String$join,
									'',
									$elm$core$List$reverse(context));
							}
						}();
					} else {
						if (!errors.b.b) {
							var err = errors.a;
							var $temp$error = err,
								$temp$context = context;
							error = $temp$error;
							context = $temp$context;
							continue errorToStringHelp;
						} else {
							var starter = function () {
								if (!context.b) {
									return 'Json.Decode.oneOf';
								} else {
									return 'The Json.Decode.oneOf at json' + A2(
										$elm$core$String$join,
										'',
										$elm$core$List$reverse(context));
								}
							}();
							var introduction = starter + (' failed in the following ' + ($elm$core$String$fromInt(
								$elm$core$List$length(errors)) + ' ways:'));
							return A2(
								$elm$core$String$join,
								'\n\n',
								A2(
									$elm$core$List$cons,
									introduction,
									A2($elm$core$List$indexedMap, $elm$json$Json$Decode$errorOneOf, errors)));
						}
					}
				default:
					var msg = error.a;
					var json = error.b;
					var introduction = function () {
						if (!context.b) {
							return 'Problem with the given value:\n\n';
						} else {
							return 'Problem with the value at json' + (A2(
								$elm$core$String$join,
								'',
								$elm$core$List$reverse(context)) + ':\n\n    ');
						}
					}();
					return introduction + ($elm$json$Json$Decode$indent(
						A2($elm$json$Json$Encode$encode, 4, json)) + ('\n\n' + msg));
			}
		}
	});
var $elm$core$Array$branchFactor = 32;
var $elm$core$Array$Array_elm_builtin = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $elm$core$Elm$JsArray$empty = _JsArray_empty;
var $elm$core$Basics$ceiling = _Basics_ceiling;
var $elm$core$Basics$fdiv = _Basics_fdiv;
var $elm$core$Basics$logBase = F2(
	function (base, number) {
		return _Basics_log(number) / _Basics_log(base);
	});
var $elm$core$Basics$toFloat = _Basics_toFloat;
var $elm$core$Array$shiftStep = $elm$core$Basics$ceiling(
	A2($elm$core$Basics$logBase, 2, $elm$core$Array$branchFactor));
var $elm$core$Array$empty = A4($elm$core$Array$Array_elm_builtin, 0, $elm$core$Array$shiftStep, $elm$core$Elm$JsArray$empty, $elm$core$Elm$JsArray$empty);
var $elm$core$Elm$JsArray$initialize = _JsArray_initialize;
var $elm$core$Array$Leaf = function (a) {
	return {$: 1, a: a};
};
var $elm$core$Basics$apL = F2(
	function (f, x) {
		return f(x);
	});
var $elm$core$Basics$apR = F2(
	function (x, f) {
		return f(x);
	});
var $elm$core$Basics$eq = _Utils_equal;
var $elm$core$Basics$floor = _Basics_floor;
var $elm$core$Elm$JsArray$length = _JsArray_length;
var $elm$core$Basics$gt = _Utils_gt;
var $elm$core$Basics$max = F2(
	function (x, y) {
		return (_Utils_cmp(x, y) > 0) ? x : y;
	});
var $elm$core$Basics$mul = _Basics_mul;
var $elm$core$Array$SubTree = function (a) {
	return {$: 0, a: a};
};
var $elm$core$Elm$JsArray$initializeFromList = _JsArray_initializeFromList;
var $elm$core$Array$compressNodes = F2(
	function (nodes, acc) {
		compressNodes:
		while (true) {
			var _v0 = A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodes);
			var node = _v0.a;
			var remainingNodes = _v0.b;
			var newAcc = A2(
				$elm$core$List$cons,
				$elm$core$Array$SubTree(node),
				acc);
			if (!remainingNodes.b) {
				return $elm$core$List$reverse(newAcc);
			} else {
				var $temp$nodes = remainingNodes,
					$temp$acc = newAcc;
				nodes = $temp$nodes;
				acc = $temp$acc;
				continue compressNodes;
			}
		}
	});
var $elm$core$Tuple$first = function (_v0) {
	var x = _v0.a;
	return x;
};
var $elm$core$Array$treeFromBuilder = F2(
	function (nodeList, nodeListSize) {
		treeFromBuilder:
		while (true) {
			var newNodeSize = $elm$core$Basics$ceiling(nodeListSize / $elm$core$Array$branchFactor);
			if (newNodeSize === 1) {
				return A2($elm$core$Elm$JsArray$initializeFromList, $elm$core$Array$branchFactor, nodeList).a;
			} else {
				var $temp$nodeList = A2($elm$core$Array$compressNodes, nodeList, _List_Nil),
					$temp$nodeListSize = newNodeSize;
				nodeList = $temp$nodeList;
				nodeListSize = $temp$nodeListSize;
				continue treeFromBuilder;
			}
		}
	});
var $elm$core$Array$builderToArray = F2(
	function (reverseNodeList, builder) {
		if (!builder.k) {
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.l),
				$elm$core$Array$shiftStep,
				$elm$core$Elm$JsArray$empty,
				builder.l);
		} else {
			var treeLen = builder.k * $elm$core$Array$branchFactor;
			var depth = $elm$core$Basics$floor(
				A2($elm$core$Basics$logBase, $elm$core$Array$branchFactor, treeLen - 1));
			var correctNodeList = reverseNodeList ? $elm$core$List$reverse(builder.m) : builder.m;
			var tree = A2($elm$core$Array$treeFromBuilder, correctNodeList, builder.k);
			return A4(
				$elm$core$Array$Array_elm_builtin,
				$elm$core$Elm$JsArray$length(builder.l) + treeLen,
				A2($elm$core$Basics$max, 5, depth * $elm$core$Array$shiftStep),
				tree,
				builder.l);
		}
	});
var $elm$core$Basics$idiv = _Basics_idiv;
var $elm$core$Basics$lt = _Utils_lt;
var $elm$core$Array$initializeHelp = F5(
	function (fn, fromIndex, len, nodeList, tail) {
		initializeHelp:
		while (true) {
			if (fromIndex < 0) {
				return A2(
					$elm$core$Array$builderToArray,
					false,
					{m: nodeList, k: (len / $elm$core$Array$branchFactor) | 0, l: tail});
			} else {
				var leaf = $elm$core$Array$Leaf(
					A3($elm$core$Elm$JsArray$initialize, $elm$core$Array$branchFactor, fromIndex, fn));
				var $temp$fn = fn,
					$temp$fromIndex = fromIndex - $elm$core$Array$branchFactor,
					$temp$len = len,
					$temp$nodeList = A2($elm$core$List$cons, leaf, nodeList),
					$temp$tail = tail;
				fn = $temp$fn;
				fromIndex = $temp$fromIndex;
				len = $temp$len;
				nodeList = $temp$nodeList;
				tail = $temp$tail;
				continue initializeHelp;
			}
		}
	});
var $elm$core$Basics$remainderBy = _Basics_remainderBy;
var $elm$core$Array$initialize = F2(
	function (len, fn) {
		if (len <= 0) {
			return $elm$core$Array$empty;
		} else {
			var tailLen = len % $elm$core$Array$branchFactor;
			var tail = A3($elm$core$Elm$JsArray$initialize, tailLen, len - tailLen, fn);
			var initialFromIndex = (len - tailLen) - $elm$core$Array$branchFactor;
			return A5($elm$core$Array$initializeHelp, fn, initialFromIndex, len, _List_Nil, tail);
		}
	});
var $elm$core$Basics$True = 0;
var $elm$core$Result$isOk = function (result) {
	if (!result.$) {
		return true;
	} else {
		return false;
	}
};
var $elm$core$Platform$Cmd$batch = _Platform_batch;
var $elm$core$Platform$Cmd$none = $elm$core$Platform$Cmd$batch(_List_Nil);
var $elm$core$Basics$identity = function (x) {
	return x;
};
var $author$project$ParseMain$GotFile = $elm$core$Basics$identity;
var $elm$json$Json$Decode$string = _Json_decodeString;
var $author$project$ParseMain$requestParsing = _Platform_incomingPort('requestParsing', $elm$json$Json$Decode$string);
var $author$project$ParseMain$subscriptions = $author$project$ParseMain$requestParsing($elm$core$Basics$identity);
var $elm$json$Json$Decode$succeed = _Json_succeed;
var $author$project$Elm$Review$Vendor$Serialize$getJsonEncoder = function (_v0) {
	var m = _v0;
	return m.v;
};
var $elm$json$Json$Encode$int = _Json_wrap;
var $elm$json$Json$Encode$list = F2(
	function (func, entries) {
		return _Json_wrap(
			A3(
				$elm$core$List$foldl,
				_Json_addEntry(func),
				_Json_emptyArray(0),
				entries));
	});
var $author$project$Elm$Review$Vendor$Serialize$version = 1;
var $author$project$Elm$Review$Vendor$Serialize$encodeToJson = F2(
	function (codec, value) {
		return A2(
			$elm$json$Json$Encode$list,
			$elm$core$Basics$identity,
			_List_fromArray(
				[
					$elm$json$Json$Encode$int($author$project$Elm$Review$Vendor$Serialize$version),
					A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, codec, value)
				]));
	});
var $stil4m$elm_syntax$Elm$Syntax$File$File = F4(
	function (moduleDefinition, imports, declarations, comments) {
		return {ao: comments, T: declarations, as: imports, aw: moduleDefinition};
	});
var $stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Declaration$Destructuring = F2(
	function (a, b) {
		return {$: 5, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Declaration$InfixDeclaration = function (a) {
	return {$: 4, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Declaration$PortDeclaration = function (a) {
	return {$: 3, a: a};
};
var $author$project$Elm$Review$Vendor$Serialize$CustomTypeCodec = $elm$core$Basics$identity;
var $author$project$Elm$Review$Vendor$Serialize$customType = function (match) {
	return {
		B: 0,
		o: function (_v0) {
			return $elm$core$Basics$identity;
		},
		G: match
	};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Application = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$CaseBlock = F2(
	function (expression, cases) {
		return {am: cases, E: expression};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$CaseExpression = function (a) {
	return {$: 16, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$CharLiteral = function (a) {
	return {$: 12, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Floatable = function (a) {
	return {$: 9, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Function = F3(
	function (documentation, signature, declaration) {
		return {ar: declaration, K: documentation, ay: signature};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$FunctionImplementation = F3(
	function (name, _arguments, expression) {
		return {Q: _arguments, E: expression, N: name};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue = F2(
	function (a, b) {
		return {$: 3, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$GLSLExpression = function (a) {
	return {$: 23, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Hex = function (a) {
	return {$: 8, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$IfBlock = F3(
	function (a, b, c) {
		return {$: 4, a: a, b: b, c: c};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$Integer = function (a) {
	return {$: 7, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Lambda = F2(
	function (args, expression) {
		return {al: args, E: expression};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$LambdaExpression = function (a) {
	return {$: 17, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$LetBlock = F2(
	function (declarations, expression) {
		return {T: declarations, E: expression};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$LetDestructuring = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$LetExpression = function (a) {
	return {$: 15, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$LetFunction = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr = function (a) {
	return {$: 19, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Literal = function (a) {
	return {$: 11, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Negation = function (a) {
	return {$: 10, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$Operator = function (a) {
	return {$: 6, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$OperatorApplication = F4(
	function (a, b, c, d) {
		return {$: 2, a: a, b: b, c: c, d: d};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression = function (a) {
	return {$: 14, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$PrefixOperator = function (a) {
	return {$: 5, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess = F2(
	function (a, b) {
		return {$: 20, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccessFunction = function (a) {
	return {$: 21, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr = function (a) {
	return {$: 18, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$RecordUpdateExpression = F2(
	function (a, b) {
		return {$: 22, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression = function (a) {
	return {$: 13, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Expression$UnitExpr = {$: 0};
var $author$project$Elm$Review$AstCodec$InvalidChar = 0;
var $elm$core$String$cons = _String_cons;
var $elm$core$String$fromChar = function (_char) {
	return A2($elm$core$String$cons, _char, '');
};
var $author$project$Elm$Review$Vendor$Serialize$CustomError = function (a) {
	return {$: 0, a: a};
};
var $author$project$Elm$Review$Vendor$Serialize$Codec = $elm$core$Basics$identity;
var $author$project$Elm$Review$Vendor$Serialize$build = F2(
	function (jsonEncoder, jsonDecoder) {
		return {o: jsonDecoder, v: jsonEncoder};
	});
var $author$project$Elm$Review$Vendor$Serialize$getJsonDecoder = function (_v0) {
	var m = _v0;
	return m.o;
};
var $elm$json$Json$Decode$map = _Json_map1;
var $elm$core$Result$mapError = F2(
	function (f, result) {
		if (!result.$) {
			var v = result.a;
			return $elm$core$Result$Ok(v);
		} else {
			var e = result.a;
			return $elm$core$Result$Err(
				f(e));
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$mapValid = F3(
	function (fromBytes_, toBytes_, codec) {
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$build,
			function (v) {
				return A2(
					$author$project$Elm$Review$Vendor$Serialize$getJsonEncoder,
					codec,
					toBytes_(v));
			},
			A2(
				$elm$json$Json$Decode$map,
				function (value) {
					if (!value.$) {
						var ok = value.a;
						return A2(
							$elm$core$Result$mapError,
							$author$project$Elm$Review$Vendor$Serialize$CustomError,
							fromBytes_(ok));
					} else {
						var err = value.a;
						return $elm$core$Result$Err(err);
					}
				},
				$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(codec)));
	});
var $elm$json$Json$Encode$string = _Json_wrap;
var $author$project$Elm$Review$Vendor$Serialize$string = A2(
	$author$project$Elm$Review$Vendor$Serialize$build,
	$elm$json$Json$Encode$string,
	A2($elm$json$Json$Decode$map, $elm$core$Result$Ok, $elm$json$Json$Decode$string));
var $elm$core$String$foldr = _String_foldr;
var $elm$core$String$toList = function (string) {
	return A3($elm$core$String$foldr, $elm$core$List$cons, _List_Nil, string);
};
var $author$project$Elm$Review$AstCodec$char = A3(
	$author$project$Elm$Review$Vendor$Serialize$mapValid,
	function (string) {
		var _v0 = $elm$core$String$toList(string);
		if (_v0.b) {
			var head = _v0.a;
			return $elm$core$Result$Ok(head);
		} else {
			return $elm$core$Result$Err(0);
		}
	},
	$elm$core$String$fromChar,
	$author$project$Elm$Review$Vendor$Serialize$string);
var $author$project$Elm$Review$Vendor$Serialize$RecordCodec = $elm$core$Basics$identity;
var $elm$json$Json$Decode$index = _Json_decodeIndex;
var $elm$json$Json$Decode$map2 = _Json_map2;
var $author$project$Elm$Review$Vendor$Serialize$field = F3(
	function (getter, codec, _v0) {
		var recordCodec = _v0;
		return {
			F: recordCodec.F + 1,
			o: A3(
				$elm$json$Json$Decode$map2,
				F2(
					function (f, x) {
						var _v1 = _Utils_Tuple2(f, x);
						if (!_v1.a.$) {
							if (!_v1.b.$) {
								var fOk = _v1.a.a;
								var xOk = _v1.b.a;
								return $elm$core$Result$Ok(
									fOk(xOk));
							} else {
								var err = _v1.b.a;
								return $elm$core$Result$Err(err);
							}
						} else {
							var err = _v1.a.a;
							return $elm$core$Result$Err(err);
						}
					}),
				recordCodec.o,
				A2(
					$elm$json$Json$Decode$index,
					recordCodec.F,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(codec))),
			v: function (v) {
				return A2(
					$elm$core$List$cons,
					A2(
						$author$project$Elm$Review$Vendor$Serialize$getJsonEncoder,
						codec,
						getter(v)),
					recordCodec.v(v));
			}
		};
	});
var $author$project$Elm$Review$Vendor$Serialize$DataCorrupted = {$: 1};
var $elm$json$Json$Decode$andThen = _Json_andThen;
var $elm$core$Basics$composeR = F2(function $elm$core$Basics$composeR$fn(f, g) {
  return function(x) {
    return g(f(x));
  };
});
var $elm$json$Json$Decode$int = _Json_decodeInt;
var $author$project$Elm$Review$Vendor$Serialize$finishCustomType = function (_v0) {
	var am = _v0;
	return A2(
		$author$project$Elm$Review$Vendor$Serialize$build,
		A2(
			$elm$core$Basics$composeR,
			am.G,
			function (_v1) {
				var _v2 = _v1;
				var a = _v2.b;
				return a;
			}),
		A2(
			$elm$json$Json$Decode$andThen,
			function (tag) {
				return A2(
					am.o,
					tag,
					$elm$json$Json$Decode$succeed(
						$elm$core$Result$Err($author$project$Elm$Review$Vendor$Serialize$DataCorrupted)));
			},
			A2($elm$json$Json$Decode$index, 0, $elm$json$Json$Decode$int)));
};
var $author$project$Elm$Review$Vendor$Serialize$finishRecord = function (_v0) {
	var codec = _v0;
	return {
		o: codec.o,
		v: A2(
			$elm$core$Basics$composeR,
			codec.v,
			A2(
				$elm$core$Basics$composeR,
				$elm$core$List$reverse,
				$elm$json$Json$Encode$list($elm$core$Basics$identity)))
	};
};
var $elm$json$Json$Decode$float = _Json_decodeFloat;
var $elm$json$Json$Encode$float = _Json_wrap;
var $author$project$Elm$Review$Vendor$Serialize$float = A2(
	$author$project$Elm$Review$Vendor$Serialize$build,
	$elm$json$Json$Encode$float,
	A2($elm$json$Json$Decode$map, $elm$core$Result$Ok, $elm$json$Json$Decode$float));
var $stil4m$elm_syntax$Elm$Syntax$Infix$Left = 0;
var $stil4m$elm_syntax$Elm$Syntax$Infix$Non = 2;
var $stil4m$elm_syntax$Elm$Syntax$Infix$Right = 1;
var $author$project$Elm$Review$Vendor$Serialize$findIndexHelp = F3(
	function (index, predicate, list_) {
		findIndexHelp:
		while (true) {
			if (!list_.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var x = list_.a;
				var xs = list_.b;
				if (predicate(x)) {
					return $elm$core$Maybe$Just(index);
				} else {
					var $temp$index = index + 1,
						$temp$predicate = predicate,
						$temp$list_ = xs;
					index = $temp$index;
					predicate = $temp$predicate;
					list_ = $temp$list_;
					continue findIndexHelp;
				}
			}
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$findIndex = $author$project$Elm$Review$Vendor$Serialize$findIndexHelp(0);
var $elm$core$List$drop = F2(
	function (n, list) {
		drop:
		while (true) {
			if (n <= 0) {
				return list;
			} else {
				if (!list.b) {
					return list;
				} else {
					var x = list.a;
					var xs = list.b;
					var $temp$n = n - 1,
						$temp$list = xs;
					n = $temp$n;
					list = $temp$list;
					continue drop;
				}
			}
		}
	});
var $elm$core$List$head = function (list) {
	if (list.b) {
		var x = list.a;
		var xs = list.b;
		return $elm$core$Maybe$Just(x);
	} else {
		return $elm$core$Maybe$Nothing;
	}
};
var $author$project$Elm$Review$Vendor$Serialize$getAt = F2(
	function (idx, xs) {
		return (idx < 0) ? $elm$core$Maybe$Nothing : $elm$core$List$head(
			A2($elm$core$List$drop, idx, xs));
	});
var $elm$core$Basics$negate = function (n) {
	return -n;
};
var $elm$core$Maybe$withDefault = F2(
	function (_default, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return value;
		} else {
			return _default;
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$enum = F2(
	function (defaultItem, items) {
		var getItem = function (index) {
			return (index < 0) ? $elm$core$Result$Err($author$project$Elm$Review$Vendor$Serialize$DataCorrupted) : ((_Utils_cmp(
				index,
				$elm$core$List$length(items)) > 0) ? $elm$core$Result$Err($author$project$Elm$Review$Vendor$Serialize$DataCorrupted) : $elm$core$Result$Ok(
				A2(
					$elm$core$Maybe$withDefault,
					defaultItem,
					A2($author$project$Elm$Review$Vendor$Serialize$getAt, index - 1, items))));
		};
		var getIndex = function (value) {
			return 1 + A2(
				$elm$core$Maybe$withDefault,
				-1,
				A2(
					$author$project$Elm$Review$Vendor$Serialize$findIndex,
					$elm$core$Basics$eq(value),
					items));
		};
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$build,
			A2($elm$core$Basics$composeR, getIndex, $elm$json$Json$Encode$int),
			A2($elm$json$Json$Decode$map, getItem, $elm$json$Json$Decode$int));
	});
var $author$project$Elm$Review$AstCodec$infixDirection = A2(
	$author$project$Elm$Review$Vendor$Serialize$enum,
	0,
	_List_fromArray(
		[1, 2]));
var $author$project$Elm$Review$Vendor$Serialize$int = A2(
	$author$project$Elm$Review$Vendor$Serialize$build,
	$elm$json$Json$Encode$int,
	A2($elm$json$Json$Decode$map, $elm$core$Result$Ok, $elm$json$Json$Decode$int));
var $author$project$Elm$Review$Vendor$Serialize$lazy = function (f) {
	return A2(
		$author$project$Elm$Review$Vendor$Serialize$build,
		function (value) {
			return A2(
				$author$project$Elm$Review$Vendor$Serialize$getJsonEncoder,
				f(0),
				value);
		},
		A2(
			$elm$json$Json$Decode$andThen,
			function (_v0) {
				return $author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(
					f(0));
			},
			$elm$json$Json$Decode$succeed(0)));
};
var $elm$core$List$foldrHelper = F4(
	function (fn, acc, ctr, ls) {
		if (!ls.b) {
			return acc;
		} else {
			var a = ls.a;
			var r1 = ls.b;
			if (!r1.b) {
				return A2(fn, a, acc);
			} else {
				var b = r1.a;
				var r2 = r1.b;
				if (!r2.b) {
					return A2(
						fn,
						a,
						A2(fn, b, acc));
				} else {
					var c = r2.a;
					var r3 = r2.b;
					if (!r3.b) {
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(fn, c, acc)));
					} else {
						var d = r3.a;
						var r4 = r3.b;
						var res = (ctr > 500) ? A3(
							$elm$core$List$foldl,
							fn,
							acc,
							$elm$core$List$reverse(r4)) : A4($elm$core$List$foldrHelper, fn, acc, ctr + 1, r4);
						return A2(
							fn,
							a,
							A2(
								fn,
								b,
								A2(
									fn,
									c,
									A2(fn, d, res))));
					}
				}
			}
		}
	});
var $elm$core$List$foldr = F3(
	function (fn, acc, ls) {
		return A4($elm$core$List$foldrHelper, fn, acc, 0, ls);
	});
var $elm$json$Json$Decode$list = _Json_decodeList;
var $author$project$Elm$Review$Vendor$Serialize$list = function (codec) {
	return A2(
		$author$project$Elm$Review$Vendor$Serialize$build,
		$elm$json$Json$Encode$list(
			$author$project$Elm$Review$Vendor$Serialize$getJsonEncoder(codec)),
		A2(
			$elm$json$Json$Decode$map,
			A2(
				$elm$core$List$foldr,
				F2(
					function (value, state) {
						var _v0 = _Utils_Tuple2(value, state);
						if (_v0.b.$ === 1) {
							return state;
						} else {
							if (!_v0.a.$) {
								var ok = _v0.a.a;
								var okState = _v0.b.a;
								return $elm$core$Result$Ok(
									A2($elm$core$List$cons, ok, okState));
							} else {
								var error = _v0.a.a;
								return $elm$core$Result$Err(error);
							}
						}
					}),
				$elm$core$Result$Ok(_List_Nil)),
			$elm$json$Json$Decode$list(
				$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(codec))));
};
var $author$project$Elm$Review$Vendor$Serialize$VariantEncoder = $elm$core$Basics$identity;
var $author$project$Elm$Review$Vendor$Serialize$variant = F3(
	function (matchJsonPiece, jsonDecoderPiece, _v0) {
		var am = _v0;
		var jsonEnc = function (v) {
			return _Utils_Tuple2(
				0,
				A2(
					$elm$json$Json$Encode$list,
					$elm$core$Basics$identity,
					A2(
						$elm$core$List$cons,
						$elm$json$Json$Encode$int(am.B),
						v)));
		};
		var jsonDecoder_ = F2(
			function (tag, orElse) {
				return _Utils_eq(tag, am.B) ? jsonDecoderPiece : A2(am.o, tag, orElse);
			});
		return {
			B: am.B + 1,
			o: jsonDecoder_,
			G: am.G(
				matchJsonPiece(jsonEnc))
		};
	});
var $author$project$Elm$Review$Vendor$Serialize$variant0 = function (ctor) {
	return A2(
		$author$project$Elm$Review$Vendor$Serialize$variant,
		function (c) {
			return c(_List_Nil);
		},
		$elm$json$Json$Decode$succeed(
			$elm$core$Result$Ok(ctor)));
};
var $author$project$Elm$Review$Vendor$Serialize$result1 = F2(
	function (ctor, value) {
		if (!value.$) {
			var ok = value.a;
			return $elm$core$Result$Ok(
				ctor(ok));
		} else {
			var err = value.a;
			return $elm$core$Result$Err(err);
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$variant1 = F2(
	function (ctor, m1) {
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$variant,
			F2(
				function (c, v) {
					return c(
						_List_fromArray(
							[
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m1, v)
							]));
				}),
			A2(
				$elm$json$Json$Decode$map,
				$author$project$Elm$Review$Vendor$Serialize$result1(ctor),
				A2(
					$elm$json$Json$Decode$index,
					1,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m1))));
	});
var $author$project$Elm$Review$Vendor$Serialize$maybe = function (justCodec) {
	return $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$elm$core$Maybe$Just,
			justCodec,
			A2(
				$author$project$Elm$Review$Vendor$Serialize$variant0,
				$elm$core$Maybe$Nothing,
				$author$project$Elm$Review$Vendor$Serialize$customType(
					F3(
						function (nothingEncoder, justEncoder, value) {
							if (value.$ === 1) {
								return nothingEncoder;
							} else {
								var value_ = value.a;
								return justEncoder(value_);
							}
						})))));
};
var $stil4m$elm_syntax$Elm$Syntax$Node$Node = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $author$project$Elm$Review$Vendor$Serialize$record = function (ctor) {
	return {
		F: 0,
		o: $elm$json$Json$Decode$succeed(
			$elm$core$Result$Ok(ctor)),
		v: function (_v0) {
			return _List_Nil;
		}
	};
};
var $author$project$Elm$Review$AstCodec$node = function (codec) {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function (_v4) {
				var a = _v4.b;
				return a;
			},
			codec,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function (_v3) {
					var range_ = _v3.a;
					return range_.w.p;
				},
				$author$project$Elm$Review$Vendor$Serialize$int,
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function (_v2) {
						var range_ = _v2.a;
						return range_.w.t;
					},
					$author$project$Elm$Review$Vendor$Serialize$int,
					A3(
						$author$project$Elm$Review$Vendor$Serialize$field,
						function (_v1) {
							var range_ = _v1.a;
							return range_.z.p;
						},
						$author$project$Elm$Review$Vendor$Serialize$int,
						A3(
							$author$project$Elm$Review$Vendor$Serialize$field,
							function (_v0) {
								var range_ = _v0.a;
								return range_.z.t;
							},
							$author$project$Elm$Review$Vendor$Serialize$int,
							$author$project$Elm$Review$Vendor$Serialize$record(
								F5(
									function (a, b, c, d, e) {
										return A2(
											$stil4m$elm_syntax$Elm$Syntax$Node$Node,
											{
												w: {p: d, t: c},
												z: {p: b, t: a}
											},
											e);
									}))))))));
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$AllPattern = {$: 0};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$AsPattern = F2(
	function (a, b) {
		return {$: 13, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Pattern$CharPattern = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$FloatPattern = function (a) {
	return {$: 6, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$HexPattern = function (a) {
	return {$: 5, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$IntPattern = function (a) {
	return {$: 4, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$ListPattern = function (a) {
	return {$: 10, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern = F2(
	function (a, b) {
		return {$: 12, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern = function (a) {
	return {$: 14, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$RecordPattern = function (a) {
	return {$: 8, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$StringPattern = function (a) {
	return {$: 3, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$TuplePattern = function (a) {
	return {$: 7, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$UnConsPattern = F2(
	function (a, b) {
		return {$: 9, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$Pattern$UnitPattern = {$: 1};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern = function (a) {
	return {$: 11, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Pattern$QualifiedNameRef = F2(
	function (moduleName, name) {
		return {H: moduleName, N: name};
	});
var $author$project$Elm$Review$AstCodec$qualifiedNameRef = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.N;
		},
		$author$project$Elm$Review$Vendor$Serialize$string,
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.H;
			},
			$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string),
			$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Pattern$QualifiedNameRef))));
var $author$project$Elm$Review$Vendor$Serialize$result2 = F3(
	function (ctor, v1, v2) {
		var _v0 = _Utils_Tuple2(v1, v2);
		if (!_v0.a.$) {
			if (!_v0.b.$) {
				var ok1 = _v0.a.a;
				var ok2 = _v0.b.a;
				return $elm$core$Result$Ok(
					A2(ctor, ok1, ok2));
			} else {
				var err = _v0.b.a;
				return $elm$core$Result$Err(err);
			}
		} else {
			var err = _v0.a.a;
			return $elm$core$Result$Err(err);
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$variant2 = F3(
	function (ctor, m1, m2) {
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$variant,
			F3(
				function (c, v1, v2) {
					return c(
						_List_fromArray(
							[
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m1, v1),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m2, v2)
							]));
				}),
			A3(
				$elm$json$Json$Decode$map2,
				$author$project$Elm$Review$Vendor$Serialize$result2(ctor),
				A2(
					$elm$json$Json$Decode$index,
					1,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m1)),
				A2(
					$elm$json$Json$Decode$index,
					2,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m2))));
	});
function $author$project$Elm$Review$AstCodec$cyclic$pattern() {
	return $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern,
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyPattern()),
			A4(
				$author$project$Elm$Review$Vendor$Serialize$variant2,
				$stil4m$elm_syntax$Elm$Syntax$Pattern$AsPattern,
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$AstCodec$cyclic$lazyPattern()),
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
				A4(
					$author$project$Elm$Review$Vendor$Serialize$variant2,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern,
					$author$project$Elm$Review$AstCodec$qualifiedNameRef,
					$author$project$Elm$Review$Vendor$Serialize$list(
						$author$project$Elm$Review$AstCodec$node(
							$author$project$Elm$Review$AstCodec$cyclic$lazyPattern())),
					A3(
						$author$project$Elm$Review$Vendor$Serialize$variant1,
						$stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern,
						$author$project$Elm$Review$Vendor$Serialize$string,
						A3(
							$author$project$Elm$Review$Vendor$Serialize$variant1,
							$stil4m$elm_syntax$Elm$Syntax$Pattern$ListPattern,
							$author$project$Elm$Review$Vendor$Serialize$list(
								$author$project$Elm$Review$AstCodec$node(
									$author$project$Elm$Review$AstCodec$cyclic$lazyPattern())),
							A4(
								$author$project$Elm$Review$Vendor$Serialize$variant2,
								$stil4m$elm_syntax$Elm$Syntax$Pattern$UnConsPattern,
								$author$project$Elm$Review$AstCodec$node(
									$author$project$Elm$Review$AstCodec$cyclic$lazyPattern()),
								$author$project$Elm$Review$AstCodec$node(
									$author$project$Elm$Review$AstCodec$cyclic$lazyPattern()),
								A3(
									$author$project$Elm$Review$Vendor$Serialize$variant1,
									$stil4m$elm_syntax$Elm$Syntax$Pattern$RecordPattern,
									$author$project$Elm$Review$Vendor$Serialize$list(
										$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
									A3(
										$author$project$Elm$Review$Vendor$Serialize$variant1,
										$stil4m$elm_syntax$Elm$Syntax$Pattern$TuplePattern,
										$author$project$Elm$Review$Vendor$Serialize$list(
											$author$project$Elm$Review$AstCodec$node(
												$author$project$Elm$Review$AstCodec$cyclic$lazyPattern())),
										A3(
											$author$project$Elm$Review$Vendor$Serialize$variant1,
											$stil4m$elm_syntax$Elm$Syntax$Pattern$FloatPattern,
											$author$project$Elm$Review$Vendor$Serialize$float,
											A3(
												$author$project$Elm$Review$Vendor$Serialize$variant1,
												$stil4m$elm_syntax$Elm$Syntax$Pattern$HexPattern,
												$author$project$Elm$Review$Vendor$Serialize$int,
												A3(
													$author$project$Elm$Review$Vendor$Serialize$variant1,
													$stil4m$elm_syntax$Elm$Syntax$Pattern$IntPattern,
													$author$project$Elm$Review$Vendor$Serialize$int,
													A3(
														$author$project$Elm$Review$Vendor$Serialize$variant1,
														$stil4m$elm_syntax$Elm$Syntax$Pattern$StringPattern,
														$author$project$Elm$Review$Vendor$Serialize$string,
														A3(
															$author$project$Elm$Review$Vendor$Serialize$variant1,
															$stil4m$elm_syntax$Elm$Syntax$Pattern$CharPattern,
															$author$project$Elm$Review$AstCodec$char,
															A2(
																$author$project$Elm$Review$Vendor$Serialize$variant0,
																$stil4m$elm_syntax$Elm$Syntax$Pattern$UnitPattern,
																A2(
																	$author$project$Elm$Review$Vendor$Serialize$variant0,
																	$stil4m$elm_syntax$Elm$Syntax$Pattern$AllPattern,
																	$author$project$Elm$Review$Vendor$Serialize$customType(
																		function (e0) {
																			return function (e1) {
																				return function (e2) {
																					return function (e3) {
																						return function (e4) {
																							return function (e5) {
																								return function (e6) {
																									return function (e7) {
																										return function (e8) {
																											return function (e9) {
																												return function (e10) {
																													return function (e11) {
																														return function (e12) {
																															return function (e13) {
																																return function (e14) {
																																	return function (value) {
																																		switch (value.$) {
																																			case 0:
																																				return e0;
																																			case 1:
																																				return e1;
																																			case 2:
																																				var a = value.a;
																																				return e2(a);
																																			case 3:
																																				var a = value.a;
																																				return e3(a);
																																			case 4:
																																				var a = value.a;
																																				return e4(a);
																																			case 5:
																																				var a = value.a;
																																				return e5(a);
																																			case 6:
																																				var a = value.a;
																																				return e6(a);
																																			case 7:
																																				var a = value.a;
																																				return e7(a);
																																			case 8:
																																				var a = value.a;
																																				return e8(a);
																																			case 9:
																																				var a = value.a;
																																				var b = value.b;
																																				return A2(e9, a, b);
																																			case 10:
																																				var a = value.a;
																																				return e10(a);
																																			case 11:
																																				var a = value.a;
																																				return e11(a);
																																			case 12:
																																				var a = value.a;
																																				var b = value.b;
																																				return A2(e12, a, b);
																																			case 13:
																																				var a = value.a;
																																				var b = value.b;
																																				return A2(e13, a, b);
																																			default:
																																				var a = value.a;
																																				return e14(a);
																																		}
																																	};
																																};
																															};
																														};
																													};
																												};
																											};
																										};
																									};
																								};
																							};
																						};
																					};
																				};
																			};
																		})))))))))))))))));
}
function $author$project$Elm$Review$AstCodec$cyclic$lazyPattern() {
	return $author$project$Elm$Review$Vendor$Serialize$lazy(
		function (_v0) {
			return $author$project$Elm$Review$AstCodec$cyclic$pattern();
		});
}
var $author$project$Elm$Review$AstCodec$pattern = $author$project$Elm$Review$AstCodec$cyclic$pattern();
$author$project$Elm$Review$AstCodec$cyclic$pattern = function () {
	return $author$project$Elm$Review$AstCodec$pattern;
};
var $author$project$Elm$Review$AstCodec$lazyPattern = $author$project$Elm$Review$AstCodec$cyclic$lazyPattern();
$author$project$Elm$Review$AstCodec$cyclic$lazyPattern = function () {
	return $author$project$Elm$Review$AstCodec$lazyPattern;
};
var $stil4m$elm_syntax$Elm$Syntax$Signature$Signature = F2(
	function (name, typeAnnotation) {
		return {N: name, ak: typeAnnotation};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation = F2(
	function (a, b) {
		return {$: 6, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericRecord = F2(
	function (a, b) {
		return {$: 5, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record = function (a) {
	return {$: 4, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled = function (a) {
	return {$: 3, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit = {$: 2};
var $elm$core$Tuple$pair = F2(
	function (a, b) {
		return _Utils_Tuple2(a, b);
	});
var $elm$core$Tuple$second = function (_v0) {
	var y = _v0.b;
	return y;
};
var $author$project$Elm$Review$Vendor$Serialize$tuple = F2(
	function (codecFirst, codecSecond) {
		return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				$elm$core$Tuple$second,
				codecSecond,
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					$elm$core$Tuple$first,
					codecFirst,
					$author$project$Elm$Review$Vendor$Serialize$record($elm$core$Tuple$pair))));
	});
function $author$project$Elm$Review$AstCodec$cyclic$typeAnnotation() {
	return $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
		A4(
			$author$project$Elm$Review$Vendor$Serialize$variant2,
			$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation,
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation()),
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation()),
			A4(
				$author$project$Elm$Review$Vendor$Serialize$variant2,
				$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericRecord,
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$AstCodec$cyclic$recordDefinition()),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$variant1,
					$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record,
					$author$project$Elm$Review$AstCodec$cyclic$recordDefinition(),
					A3(
						$author$project$Elm$Review$Vendor$Serialize$variant1,
						$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled,
						$author$project$Elm$Review$Vendor$Serialize$list(
							$author$project$Elm$Review$AstCodec$node(
								$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation())),
						A2(
							$author$project$Elm$Review$Vendor$Serialize$variant0,
							$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit,
							A4(
								$author$project$Elm$Review$Vendor$Serialize$variant2,
								$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
								$author$project$Elm$Review$AstCodec$node(
									A2(
										$author$project$Elm$Review$Vendor$Serialize$tuple,
										$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string),
										$author$project$Elm$Review$Vendor$Serialize$string)),
								$author$project$Elm$Review$Vendor$Serialize$list(
									$author$project$Elm$Review$AstCodec$node(
										$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation())),
								A3(
									$author$project$Elm$Review$Vendor$Serialize$variant1,
									$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType,
									$author$project$Elm$Review$Vendor$Serialize$string,
									$author$project$Elm$Review$Vendor$Serialize$customType(
										F8(
											function (e0, e1, e2, e3, e4, e5, e6, value) {
												switch (value.$) {
													case 0:
														var a = value.a;
														return e0(a);
													case 1:
														var a = value.a;
														var b = value.b;
														return A2(e1, a, b);
													case 2:
														return e2;
													case 3:
														var a = value.a;
														return e3(a);
													case 4:
														var a = value.a;
														return e4(a);
													case 5:
														var a = value.a;
														var b = value.b;
														return A2(e5, a, b);
													default:
														var a = value.a;
														var b = value.b;
														return A2(e6, a, b);
												}
											}))))))))));
}
function $author$project$Elm$Review$AstCodec$cyclic$recordDefinition() {
	return $author$project$Elm$Review$Vendor$Serialize$list(
		$author$project$Elm$Review$AstCodec$node(
			A2(
				$author$project$Elm$Review$Vendor$Serialize$tuple,
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation()))));
}
function $author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation() {
	return $author$project$Elm$Review$Vendor$Serialize$lazy(
		function (_v0) {
			return $author$project$Elm$Review$AstCodec$cyclic$typeAnnotation();
		});
}
var $author$project$Elm$Review$AstCodec$typeAnnotation = $author$project$Elm$Review$AstCodec$cyclic$typeAnnotation();
$author$project$Elm$Review$AstCodec$cyclic$typeAnnotation = function () {
	return $author$project$Elm$Review$AstCodec$typeAnnotation;
};
var $author$project$Elm$Review$AstCodec$recordDefinition = $author$project$Elm$Review$AstCodec$cyclic$recordDefinition();
$author$project$Elm$Review$AstCodec$cyclic$recordDefinition = function () {
	return $author$project$Elm$Review$AstCodec$recordDefinition;
};
var $author$project$Elm$Review$AstCodec$lazyTypeAnnotation = $author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation();
$author$project$Elm$Review$AstCodec$cyclic$lazyTypeAnnotation = function () {
	return $author$project$Elm$Review$AstCodec$lazyTypeAnnotation;
};
var $author$project$Elm$Review$AstCodec$signature = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.ak;
		},
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$typeAnnotation),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.N;
			},
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
			$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Signature$Signature))));
var $elm$json$Json$Decode$map3 = _Json_map3;
var $author$project$Elm$Review$Vendor$Serialize$result3 = F4(
	function (ctor, v1, v2, v3) {
		var _v0 = _Utils_Tuple3(v1, v2, v3);
		if (!_v0.a.$) {
			if (!_v0.b.$) {
				if (!_v0.c.$) {
					var ok1 = _v0.a.a;
					var ok2 = _v0.b.a;
					var ok3 = _v0.c.a;
					return $elm$core$Result$Ok(
						A3(ctor, ok1, ok2, ok3));
				} else {
					var err = _v0.c.a;
					return $elm$core$Result$Err(err);
				}
			} else {
				var err = _v0.b.a;
				return $elm$core$Result$Err(err);
			}
		} else {
			var err = _v0.a.a;
			return $elm$core$Result$Err(err);
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$variant3 = F4(
	function (ctor, m1, m2, m3) {
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$variant,
			F4(
				function (c, v1, v2, v3) {
					return c(
						_List_fromArray(
							[
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m1, v1),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m2, v2),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m3, v3)
							]));
				}),
			A4(
				$elm$json$Json$Decode$map3,
				$author$project$Elm$Review$Vendor$Serialize$result3(ctor),
				A2(
					$elm$json$Json$Decode$index,
					1,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m1)),
				A2(
					$elm$json$Json$Decode$index,
					2,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m2)),
				A2(
					$elm$json$Json$Decode$index,
					3,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m3))));
	});
var $elm$json$Json$Decode$map4 = _Json_map4;
var $author$project$Elm$Review$Vendor$Serialize$T4 = F4(
	function (a, b, c, d) {
		return {$: 0, a: a, b: b, c: c, d: d};
	});
var $author$project$Elm$Review$Vendor$Serialize$result4 = F5(
	function (ctor, v1, v2, v3, v4) {
		var _v0 = A4($author$project$Elm$Review$Vendor$Serialize$T4, v1, v2, v3, v4);
		if (!_v0.a.$) {
			if (!_v0.b.$) {
				if (!_v0.c.$) {
					if (!_v0.d.$) {
						var ok1 = _v0.a.a;
						var ok2 = _v0.b.a;
						var ok3 = _v0.c.a;
						var ok4 = _v0.d.a;
						return $elm$core$Result$Ok(
							A4(ctor, ok1, ok2, ok3, ok4));
					} else {
						var err = _v0.d.a;
						return $elm$core$Result$Err(err);
					}
				} else {
					var err = _v0.c.a;
					return $elm$core$Result$Err(err);
				}
			} else {
				var err = _v0.b.a;
				return $elm$core$Result$Err(err);
			}
		} else {
			var err = _v0.a.a;
			return $elm$core$Result$Err(err);
		}
	});
var $author$project$Elm$Review$Vendor$Serialize$variant4 = F5(
	function (ctor, m1, m2, m3, m4) {
		return A2(
			$author$project$Elm$Review$Vendor$Serialize$variant,
			F5(
				function (c, v1, v2, v3, v4) {
					return c(
						_List_fromArray(
							[
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m1, v1),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m2, v2),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m3, v3),
								A2($author$project$Elm$Review$Vendor$Serialize$getJsonEncoder, m4, v4)
							]));
				}),
			A5(
				$elm$json$Json$Decode$map4,
				$author$project$Elm$Review$Vendor$Serialize$result4(ctor),
				A2(
					$elm$json$Json$Decode$index,
					1,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m1)),
				A2(
					$elm$json$Json$Decode$index,
					2,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m2)),
				A2(
					$elm$json$Json$Decode$index,
					3,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m3)),
				A2(
					$elm$json$Json$Decode$index,
					4,
					$author$project$Elm$Review$Vendor$Serialize$getJsonDecoder(m4))));
	});
function $author$project$Elm$Review$AstCodec$cyclic$expression() {
	return $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Expression$Operator,
			$author$project$Elm$Review$Vendor$Serialize$string,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$variant1,
				$stil4m$elm_syntax$Elm$Syntax$Expression$GLSLExpression,
				$author$project$Elm$Review$Vendor$Serialize$string,
				A4(
					$author$project$Elm$Review$Vendor$Serialize$variant2,
					$stil4m$elm_syntax$Elm$Syntax$Expression$RecordUpdateExpression,
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
					$author$project$Elm$Review$Vendor$Serialize$list(
						$author$project$Elm$Review$AstCodec$node(
							$author$project$Elm$Review$AstCodec$cyclic$recordSetter())),
					A3(
						$author$project$Elm$Review$Vendor$Serialize$variant1,
						$stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccessFunction,
						$author$project$Elm$Review$Vendor$Serialize$string,
						A4(
							$author$project$Elm$Review$Vendor$Serialize$variant2,
							$stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess,
							$author$project$Elm$Review$AstCodec$node(
								$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
							$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
							A3(
								$author$project$Elm$Review$Vendor$Serialize$variant1,
								$stil4m$elm_syntax$Elm$Syntax$Expression$LambdaExpression,
								$author$project$Elm$Review$AstCodec$cyclic$lambda(),
								A3(
									$author$project$Elm$Review$Vendor$Serialize$variant1,
									$stil4m$elm_syntax$Elm$Syntax$Expression$CaseExpression,
									$author$project$Elm$Review$AstCodec$cyclic$caseBlock(),
									A3(
										$author$project$Elm$Review$Vendor$Serialize$variant1,
										$stil4m$elm_syntax$Elm$Syntax$Expression$LetExpression,
										$author$project$Elm$Review$AstCodec$cyclic$letBlock(),
										A3(
											$author$project$Elm$Review$Vendor$Serialize$variant1,
											$stil4m$elm_syntax$Elm$Syntax$Expression$CharLiteral,
											$author$project$Elm$Review$AstCodec$char,
											A3(
												$author$project$Elm$Review$Vendor$Serialize$variant1,
												$stil4m$elm_syntax$Elm$Syntax$Expression$Negation,
												$author$project$Elm$Review$AstCodec$node(
													$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
												A3(
													$author$project$Elm$Review$Vendor$Serialize$variant1,
													$stil4m$elm_syntax$Elm$Syntax$Expression$Hex,
													$author$project$Elm$Review$Vendor$Serialize$int,
													A3(
														$author$project$Elm$Review$Vendor$Serialize$variant1,
														$stil4m$elm_syntax$Elm$Syntax$Expression$PrefixOperator,
														$author$project$Elm$Review$Vendor$Serialize$string,
														A5(
															$author$project$Elm$Review$Vendor$Serialize$variant3,
															$stil4m$elm_syntax$Elm$Syntax$Expression$IfBlock,
															$author$project$Elm$Review$AstCodec$node(
																$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
															$author$project$Elm$Review$AstCodec$node(
																$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
															$author$project$Elm$Review$AstCodec$node(
																$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
															A2(
																$author$project$Elm$Review$Vendor$Serialize$variant0,
																$stil4m$elm_syntax$Elm$Syntax$Expression$UnitExpr,
																A3(
																	$author$project$Elm$Review$Vendor$Serialize$variant1,
																	$stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr,
																	$author$project$Elm$Review$Vendor$Serialize$list(
																		$author$project$Elm$Review$AstCodec$node(
																			$author$project$Elm$Review$AstCodec$cyclic$lazyExpression())),
																	A3(
																		$author$project$Elm$Review$Vendor$Serialize$variant1,
																		$stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr,
																		$author$project$Elm$Review$Vendor$Serialize$list(
																			$author$project$Elm$Review$AstCodec$node(
																				$author$project$Elm$Review$AstCodec$cyclic$recordSetter())),
																		A3(
																			$author$project$Elm$Review$Vendor$Serialize$variant1,
																			$stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression,
																			$author$project$Elm$Review$AstCodec$node(
																				$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
																			A3(
																				$author$project$Elm$Review$Vendor$Serialize$variant1,
																				$stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression,
																				$author$project$Elm$Review$Vendor$Serialize$list(
																					$author$project$Elm$Review$AstCodec$node(
																						$author$project$Elm$Review$AstCodec$cyclic$lazyExpression())),
																				A3(
																					$author$project$Elm$Review$Vendor$Serialize$variant1,
																					$stil4m$elm_syntax$Elm$Syntax$Expression$Literal,
																					$author$project$Elm$Review$Vendor$Serialize$string,
																					A3(
																						$author$project$Elm$Review$Vendor$Serialize$variant1,
																						$stil4m$elm_syntax$Elm$Syntax$Expression$Floatable,
																						$author$project$Elm$Review$Vendor$Serialize$float,
																						A3(
																							$author$project$Elm$Review$Vendor$Serialize$variant1,
																							$stil4m$elm_syntax$Elm$Syntax$Expression$Integer,
																							$author$project$Elm$Review$Vendor$Serialize$int,
																							A4(
																								$author$project$Elm$Review$Vendor$Serialize$variant2,
																								$stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue,
																								$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string),
																								$author$project$Elm$Review$Vendor$Serialize$string,
																								A6(
																									$author$project$Elm$Review$Vendor$Serialize$variant4,
																									$stil4m$elm_syntax$Elm$Syntax$Expression$OperatorApplication,
																									$author$project$Elm$Review$Vendor$Serialize$string,
																									$author$project$Elm$Review$AstCodec$infixDirection,
																									$author$project$Elm$Review$AstCodec$node(
																										$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
																									$author$project$Elm$Review$AstCodec$node(
																										$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
																									A3(
																										$author$project$Elm$Review$Vendor$Serialize$variant1,
																										$stil4m$elm_syntax$Elm$Syntax$Expression$Application,
																										$author$project$Elm$Review$Vendor$Serialize$list(
																											$author$project$Elm$Review$AstCodec$node(
																												$author$project$Elm$Review$AstCodec$cyclic$lazyExpression())),
																										$author$project$Elm$Review$Vendor$Serialize$customType(
																											function (application) {
																												return function (operatorApplication) {
																													return function (functionOrValue) {
																														return function (integer) {
																															return function (floatable) {
																																return function (literal) {
																																	return function (tuple) {
																																		return function (parenthesized) {
																																			return function (record) {
																																				return function (listExpr) {
																																					return function (unit) {
																																						return function (ifBlock) {
																																							return function (prefixOperator) {
																																								return function (hex) {
																																									return function (negation) {
																																										return function (charExpr) {
																																											return function (letExpr) {
																																												return function (caseExpr) {
																																													return function (lambdaExpr) {
																																														return function (recordAccess) {
																																															return function (recordAccessFunction) {
																																																return function (recordUpdateExpr) {
																																																	return function (glsl) {
																																																		return function (operator) {
																																																			return function (value) {
																																																				switch (value.$) {
																																																					case 1:
																																																						var a = value.a;
																																																						return application(a);
																																																					case 2:
																																																						var a = value.a;
																																																						var b = value.b;
																																																						var c = value.c;
																																																						var d = value.d;
																																																						return A4(operatorApplication, a, b, c, d);
																																																					case 3:
																																																						var a = value.a;
																																																						var b = value.b;
																																																						return A2(functionOrValue, a, b);
																																																					case 7:
																																																						var a = value.a;
																																																						return integer(a);
																																																					case 9:
																																																						var a = value.a;
																																																						return floatable(a);
																																																					case 11:
																																																						var a = value.a;
																																																						return literal(a);
																																																					case 13:
																																																						var a = value.a;
																																																						return tuple(a);
																																																					case 14:
																																																						var a = value.a;
																																																						return parenthesized(a);
																																																					case 18:
																																																						var a = value.a;
																																																						return record(a);
																																																					case 19:
																																																						var a = value.a;
																																																						return listExpr(a);
																																																					case 0:
																																																						return unit;
																																																					case 5:
																																																						var a = value.a;
																																																						return prefixOperator(a);
																																																					case 8:
																																																						var a = value.a;
																																																						return hex(a);
																																																					case 10:
																																																						var a = value.a;
																																																						return negation(a);
																																																					case 12:
																																																						var a = value.a;
																																																						return charExpr(a);
																																																					case 15:
																																																						var a = value.a;
																																																						return letExpr(a);
																																																					case 16:
																																																						var a = value.a;
																																																						return caseExpr(a);
																																																					case 17:
																																																						var a = value.a;
																																																						return lambdaExpr(a);
																																																					case 4:
																																																						var a = value.a;
																																																						var b = value.b;
																																																						var c = value.c;
																																																						return A3(ifBlock, a, b, c);
																																																					case 20:
																																																						var a = value.a;
																																																						var b = value.b;
																																																						return A2(recordAccess, a, b);
																																																					case 21:
																																																						var a = value.a;
																																																						return recordAccessFunction(a);
																																																					case 22:
																																																						var a = value.a;
																																																						var b = value.b;
																																																						return A2(recordUpdateExpr, a, b);
																																																					case 23:
																																																						var a = value.a;
																																																						return glsl(a);
																																																					default:
																																																						var a = value.a;
																																																						return operator(a);
																																																				}
																																																			};
																																																		};
																																																	};
																																																};
																																															};
																																														};
																																													};
																																												};
																																											};
																																										};
																																									};
																																								};
																																							};
																																						};
																																					};
																																				};
																																			};
																																		};
																																	};
																																};
																															};
																														};
																													};
																												};
																											}))))))))))))))))))))))))));
}
function $author$project$Elm$Review$AstCodec$cyclic$caseBlock() {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.am;
			},
			$author$project$Elm$Review$Vendor$Serialize$list(
				A2(
					$author$project$Elm$Review$Vendor$Serialize$tuple,
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$pattern),
					$author$project$Elm$Review$AstCodec$node(
						$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()))),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.E;
				},
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
				$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Expression$CaseBlock))));
}
function $author$project$Elm$Review$AstCodec$cyclic$letBlock() {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.E;
			},
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.T;
				},
				$author$project$Elm$Review$Vendor$Serialize$list(
					$author$project$Elm$Review$AstCodec$node(
						$author$project$Elm$Review$AstCodec$cyclic$letDeclaration())),
				$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Expression$LetBlock))));
}
function $author$project$Elm$Review$AstCodec$cyclic$letDeclaration() {
	return $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
		A4(
			$author$project$Elm$Review$Vendor$Serialize$variant2,
			$stil4m$elm_syntax$Elm$Syntax$Expression$LetDestructuring,
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$pattern),
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$variant1,
				$stil4m$elm_syntax$Elm$Syntax$Expression$LetFunction,
				$author$project$Elm$Review$AstCodec$cyclic$function(),
				$author$project$Elm$Review$Vendor$Serialize$customType(
					F3(
						function (e0, e1, value) {
							if (!value.$) {
								var a = value.a;
								return e0(a);
							} else {
								var a = value.a;
								var b = value.b;
								return A2(e1, a, b);
							}
						})))));
}
function $author$project$Elm$Review$AstCodec$cyclic$function() {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.ar;
			},
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$functionImplementation()),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.ay;
				},
				$author$project$Elm$Review$Vendor$Serialize$maybe(
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$signature)),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.K;
					},
					$author$project$Elm$Review$Vendor$Serialize$maybe(
						$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Expression$Function)))));
}
function $author$project$Elm$Review$AstCodec$cyclic$functionImplementation() {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.E;
			},
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.Q;
				},
				$author$project$Elm$Review$Vendor$Serialize$list(
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$pattern)),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.N;
					},
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Expression$FunctionImplementation)))));
}
function $author$project$Elm$Review$AstCodec$cyclic$lambda() {
	return $author$project$Elm$Review$Vendor$Serialize$finishRecord(
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.E;
			},
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.al;
				},
				$author$project$Elm$Review$Vendor$Serialize$list(
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$pattern)),
				$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Expression$Lambda))));
}
function $author$project$Elm$Review$AstCodec$cyclic$recordSetter() {
	return A2(
		$author$project$Elm$Review$Vendor$Serialize$tuple,
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
		$author$project$Elm$Review$AstCodec$node(
			$author$project$Elm$Review$AstCodec$cyclic$lazyExpression()));
}
function $author$project$Elm$Review$AstCodec$cyclic$lazyExpression() {
	return $author$project$Elm$Review$Vendor$Serialize$lazy(
		function (_v0) {
			return $author$project$Elm$Review$AstCodec$cyclic$expression();
		});
}
var $author$project$Elm$Review$AstCodec$expression = $author$project$Elm$Review$AstCodec$cyclic$expression();
$author$project$Elm$Review$AstCodec$cyclic$expression = function () {
	return $author$project$Elm$Review$AstCodec$expression;
};
var $author$project$Elm$Review$AstCodec$caseBlock = $author$project$Elm$Review$AstCodec$cyclic$caseBlock();
$author$project$Elm$Review$AstCodec$cyclic$caseBlock = function () {
	return $author$project$Elm$Review$AstCodec$caseBlock;
};
var $author$project$Elm$Review$AstCodec$letBlock = $author$project$Elm$Review$AstCodec$cyclic$letBlock();
$author$project$Elm$Review$AstCodec$cyclic$letBlock = function () {
	return $author$project$Elm$Review$AstCodec$letBlock;
};
var $author$project$Elm$Review$AstCodec$letDeclaration = $author$project$Elm$Review$AstCodec$cyclic$letDeclaration();
$author$project$Elm$Review$AstCodec$cyclic$letDeclaration = function () {
	return $author$project$Elm$Review$AstCodec$letDeclaration;
};
var $author$project$Elm$Review$AstCodec$function = $author$project$Elm$Review$AstCodec$cyclic$function();
$author$project$Elm$Review$AstCodec$cyclic$function = function () {
	return $author$project$Elm$Review$AstCodec$function;
};
var $author$project$Elm$Review$AstCodec$functionImplementation = $author$project$Elm$Review$AstCodec$cyclic$functionImplementation();
$author$project$Elm$Review$AstCodec$cyclic$functionImplementation = function () {
	return $author$project$Elm$Review$AstCodec$functionImplementation;
};
var $author$project$Elm$Review$AstCodec$lambda = $author$project$Elm$Review$AstCodec$cyclic$lambda();
$author$project$Elm$Review$AstCodec$cyclic$lambda = function () {
	return $author$project$Elm$Review$AstCodec$lambda;
};
var $author$project$Elm$Review$AstCodec$recordSetter = $author$project$Elm$Review$AstCodec$cyclic$recordSetter();
$author$project$Elm$Review$AstCodec$cyclic$recordSetter = function () {
	return $author$project$Elm$Review$AstCodec$recordSetter;
};
var $author$project$Elm$Review$AstCodec$lazyExpression = $author$project$Elm$Review$AstCodec$cyclic$lazyExpression();
$author$project$Elm$Review$AstCodec$cyclic$lazyExpression = function () {
	return $author$project$Elm$Review$AstCodec$lazyExpression;
};
var $stil4m$elm_syntax$Elm$Syntax$Infix$Infix = F4(
	function (direction, precedence, operator, _function) {
		return {e: direction, f: _function, h: operator, i: precedence};
	});
var $author$project$Elm$Review$AstCodec$infix_ = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.f;
		},
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.h;
			},
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.i;
				},
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$int),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.e;
					},
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$infixDirection),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Infix$Infix))))));
var $stil4m$elm_syntax$Elm$Syntax$TypeAlias$TypeAlias = F4(
	function (documentation, name, generics, typeAnnotation) {
		return {K: documentation, X: generics, N: name, ak: typeAnnotation};
	});
var $author$project$Elm$Review$AstCodec$typeAlias = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.ak;
		},
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$typeAnnotation),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.X;
			},
			$author$project$Elm$Review$Vendor$Serialize$list(
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.N;
				},
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.K;
					},
					$author$project$Elm$Review$Vendor$Serialize$maybe(
						$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$TypeAlias$TypeAlias))))));
var $stil4m$elm_syntax$Elm$Syntax$Type$Type = F4(
	function (documentation, name, generics, constructors) {
		return {ap: constructors, K: documentation, X: generics, N: name};
	});
var $stil4m$elm_syntax$Elm$Syntax$Type$ValueConstructor = F2(
	function (name, _arguments) {
		return {Q: _arguments, N: name};
	});
var $author$project$Elm$Review$AstCodec$valueConstructor = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.Q;
		},
		$author$project$Elm$Review$Vendor$Serialize$list(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$typeAnnotation)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.N;
			},
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
			$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Type$ValueConstructor))));
var $author$project$Elm$Review$AstCodec$type_ = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.ap;
		},
		$author$project$Elm$Review$Vendor$Serialize$list(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$valueConstructor)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.X;
			},
			$author$project$Elm$Review$Vendor$Serialize$list(
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.N;
				},
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.K;
					},
					$author$project$Elm$Review$Vendor$Serialize$maybe(
						$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Type$Type))))));
var $author$project$Elm$Review$AstCodec$declaration = $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
	A4(
		$author$project$Elm$Review$Vendor$Serialize$variant2,
		$stil4m$elm_syntax$Elm$Syntax$Declaration$Destructuring,
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$pattern),
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$expression),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Declaration$InfixDeclaration,
			$author$project$Elm$Review$AstCodec$infix_,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$variant1,
				$stil4m$elm_syntax$Elm$Syntax$Declaration$PortDeclaration,
				$author$project$Elm$Review$AstCodec$signature,
				A3(
					$author$project$Elm$Review$Vendor$Serialize$variant1,
					$stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration,
					$author$project$Elm$Review$AstCodec$type_,
					A3(
						$author$project$Elm$Review$Vendor$Serialize$variant1,
						$stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration,
						$author$project$Elm$Review$AstCodec$typeAlias,
						A3(
							$author$project$Elm$Review$Vendor$Serialize$variant1,
							$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration,
							$author$project$Elm$Review$AstCodec$function,
							$author$project$Elm$Review$Vendor$Serialize$customType(
								F7(
									function (e0, e1, e2, e3, e4, e5, value) {
										switch (value.$) {
											case 0:
												var a = value.a;
												return e0(a);
											case 1:
												var a = value.a;
												return e1(a);
											case 2:
												var a = value.a;
												return e2(a);
											case 3:
												var a = value.a;
												return e3(a);
											case 4:
												var a = value.a;
												return e4(a);
											default:
												var a = value.a;
												var b = value.b;
												return A2(e5, a, b);
										}
									})))))))));
var $stil4m$elm_syntax$Elm$Syntax$Import$Import = F3(
	function (moduleName, moduleAlias, exposingList) {
		return {L: exposingList, av: moduleAlias, H: moduleName};
	});
var $stil4m$elm_syntax$Elm$Syntax$Exposing$All = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit = function (a) {
	return {$: 1, a: a};
};
var $author$project$Elm$Review$AstCodec$range = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		A2(
			$elm$core$Basics$composeR,
			function ($) {
				return $.w;
			},
			function ($) {
				return $.p;
			}),
		$author$project$Elm$Review$Vendor$Serialize$int,
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			A2(
				$elm$core$Basics$composeR,
				function ($) {
					return $.w;
				},
				function ($) {
					return $.t;
				}),
			$author$project$Elm$Review$Vendor$Serialize$int,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				A2(
					$elm$core$Basics$composeR,
					function ($) {
						return $.z;
					},
					function ($) {
						return $.p;
					}),
				$author$project$Elm$Review$Vendor$Serialize$int,
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					A2(
						$elm$core$Basics$composeR,
						function ($) {
							return $.z;
						},
						function ($) {
							return $.t;
						}),
					$author$project$Elm$Review$Vendor$Serialize$int,
					$author$project$Elm$Review$Vendor$Serialize$record(
						F4(
							function (startRow, startColumn, endRow, endColumn) {
								return {
									w: {p: endColumn, t: endRow},
									z: {p: startColumn, t: startRow}
								};
							})))))));
var $stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$InfixExpose = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$TypeExpose = function (a) {
	return {$: 3, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Exposing$ExposedType = F2(
	function (name, open) {
		return {N: name, ax: open};
	});
var $author$project$Elm$Review$AstCodec$exposedType = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.ax;
		},
		$author$project$Elm$Review$Vendor$Serialize$maybe($author$project$Elm$Review$AstCodec$range),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.N;
			},
			$author$project$Elm$Review$Vendor$Serialize$string,
			$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Exposing$ExposedType))));
var $author$project$Elm$Review$AstCodec$topLevelExpose = $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$variant1,
		$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeExpose,
		$author$project$Elm$Review$AstCodec$exposedType,
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose,
			$author$project$Elm$Review$Vendor$Serialize$string,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$variant1,
				$stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose,
				$author$project$Elm$Review$Vendor$Serialize$string,
				A3(
					$author$project$Elm$Review$Vendor$Serialize$variant1,
					$stil4m$elm_syntax$Elm$Syntax$Exposing$InfixExpose,
					$author$project$Elm$Review$Vendor$Serialize$string,
					$author$project$Elm$Review$Vendor$Serialize$customType(
						F5(
							function (e0, e1, e2, e3, value) {
								switch (value.$) {
									case 0:
										var a = value.a;
										return e0(a);
									case 1:
										var a = value.a;
										return e1(a);
									case 2:
										var a = value.a;
										return e2(a);
									default:
										var a = value.a;
										return e3(a);
								}
							})))))));
var $author$project$Elm$Review$AstCodec$exposing_ = $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$variant1,
		$stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit,
		$author$project$Elm$Review$Vendor$Serialize$list(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$topLevelExpose)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Exposing$All,
			$author$project$Elm$Review$AstCodec$range,
			$author$project$Elm$Review$Vendor$Serialize$customType(
				F3(
					function (e0, e1, value) {
						if (!value.$) {
							var a = value.a;
							return e0(a);
						} else {
							var a = value.a;
							return e1(a);
						}
					})))));
var $author$project$Elm$Review$AstCodec$import_ = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.L;
		},
		$author$project$Elm$Review$Vendor$Serialize$maybe(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$exposing_)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.av;
			},
			$author$project$Elm$Review$Vendor$Serialize$maybe(
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string))),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.H;
				},
				$author$project$Elm$Review$AstCodec$node(
					$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string)),
				$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Import$Import)))));
var $stil4m$elm_syntax$Elm$Syntax$Module$EffectModule = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Module$NormalModule = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Module$PortModule = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Module$DefaultModuleData = F2(
	function (moduleName, exposingList) {
		return {L: exposingList, H: moduleName};
	});
var $author$project$Elm$Review$AstCodec$defaultModuleData = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.L;
		},
		$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$exposing_),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.H;
			},
			$author$project$Elm$Review$AstCodec$node(
				$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string)),
			$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Module$DefaultModuleData))));
var $stil4m$elm_syntax$Elm$Syntax$Module$EffectModuleData = F4(
	function (moduleName, exposingList, command, subscription) {
		return {an: command, L: exposingList, H: moduleName, az: subscription};
	});
var $author$project$Elm$Review$AstCodec$effectModuleData = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.az;
		},
		$author$project$Elm$Review$Vendor$Serialize$maybe(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.an;
			},
			$author$project$Elm$Review$Vendor$Serialize$maybe(
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.L;
				},
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$exposing_),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.H;
					},
					$author$project$Elm$Review$AstCodec$node(
						$author$project$Elm$Review$Vendor$Serialize$list($author$project$Elm$Review$Vendor$Serialize$string)),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$Module$EffectModuleData))))));
var $author$project$Elm$Review$AstCodec$module_ = $author$project$Elm$Review$Vendor$Serialize$finishCustomType(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$variant1,
		$stil4m$elm_syntax$Elm$Syntax$Module$EffectModule,
		$author$project$Elm$Review$AstCodec$effectModuleData,
		A3(
			$author$project$Elm$Review$Vendor$Serialize$variant1,
			$stil4m$elm_syntax$Elm$Syntax$Module$PortModule,
			$author$project$Elm$Review$AstCodec$defaultModuleData,
			A3(
				$author$project$Elm$Review$Vendor$Serialize$variant1,
				$stil4m$elm_syntax$Elm$Syntax$Module$NormalModule,
				$author$project$Elm$Review$AstCodec$defaultModuleData,
				$author$project$Elm$Review$Vendor$Serialize$customType(
					F4(
						function (e0, e1, e2, value) {
							switch (value.$) {
								case 0:
									var a = value.a;
									return e0(a);
								case 1:
									var a = value.a;
									return e1(a);
								default:
									var a = value.a;
									return e2(a);
							}
						}))))));
var $author$project$Elm$Review$AstCodec$file = $author$project$Elm$Review$Vendor$Serialize$finishRecord(
	A3(
		$author$project$Elm$Review$Vendor$Serialize$field,
		function ($) {
			return $.ao;
		},
		$author$project$Elm$Review$Vendor$Serialize$list(
			$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$Vendor$Serialize$string)),
		A3(
			$author$project$Elm$Review$Vendor$Serialize$field,
			function ($) {
				return $.T;
			},
			$author$project$Elm$Review$Vendor$Serialize$list(
				$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$declaration)),
			A3(
				$author$project$Elm$Review$Vendor$Serialize$field,
				function ($) {
					return $.as;
				},
				$author$project$Elm$Review$Vendor$Serialize$list(
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$import_)),
				A3(
					$author$project$Elm$Review$Vendor$Serialize$field,
					function ($) {
						return $.aw;
					},
					$author$project$Elm$Review$AstCodec$node($author$project$Elm$Review$AstCodec$module_),
					$author$project$Elm$Review$Vendor$Serialize$record($stil4m$elm_syntax$Elm$Syntax$File$File))))));
var $author$project$Elm$Review$AstCodec$encode = function (file_) {
	return A2($author$project$Elm$Review$Vendor$Serialize$encodeToJson, $author$project$Elm$Review$AstCodec$file, file_);
};
var $elm$json$Json$Encode$null = _Json_encodeNull;
var $author$project$ParseMain$parseResult = _Platform_outgoingPort('parseResult', $elm$core$Basics$identity);
var $stil4m$elm_syntax$Elm$Processing$ProcessContext = $elm$core$Basics$identity;
var $elm$core$Dict$foldl = F3(
	function (func, acc, dict) {
		foldl:
		while (true) {
			if (dict.$ === -2) {
				return acc;
			} else {
				var key = dict.b;
				var value = dict.c;
				var left = dict.d;
				var right = dict.e;
				var $temp$func = func,
					$temp$acc = A3(
					func,
					key,
					value,
					A3($elm$core$Dict$foldl, func, acc, left)),
					$temp$dict = right;
				func = $temp$func;
				acc = $temp$acc;
				dict = $temp$dict;
				continue foldl;
			}
		}
	});
var $elm$core$Dict$Black = 1;
var $elm$core$Dict$RBNode_elm_builtin = F5(
	function (a, b, c, d, e) {
		return {$: -1, a: a, b: b, c: c, d: d, e: e};
	});
var $elm$core$Dict$RBEmpty_elm_builtin = {$: -2};
var $elm$core$Dict$Red = 0;
var $elm$core$Dict$balance = F5(
	function (color, key, value, left, right) {
		if ((right.$ === -1) && (!right.a)) {
			var _v1 = right.a;
			var rK = right.b;
			var rV = right.c;
			var rLeft = right.d;
			var rRight = right.e;
			if ((left.$ === -1) && (!left.a)) {
				var _v3 = left.a;
				var lK = left.b;
				var lV = left.c;
				var lLeft = left.d;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					key,
					value,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, lK, lV, lLeft, lRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, rK, rV, rLeft, rRight));
			} else {
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					color,
					rK,
					rV,
					A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, left, rLeft),
					rRight);
			}
		} else {
			if ((((left.$ === -1) && (!left.a)) && (left.d.$ === -1)) && (!left.d.a)) {
				var _v5 = left.a;
				var lK = left.b;
				var lV = left.c;
				var _v6 = left.d;
				var _v7 = _v6.a;
				var llK = _v6.b;
				var llV = _v6.c;
				var llLeft = _v6.d;
				var llRight = _v6.e;
				var lRight = left.e;
				return A5(
					$elm$core$Dict$RBNode_elm_builtin,
					0,
					lK,
					lV,
					A5($elm$core$Dict$RBNode_elm_builtin, 1, llK, llV, llLeft, llRight),
					A5($elm$core$Dict$RBNode_elm_builtin, 1, key, value, lRight, right));
			} else {
				return A5($elm$core$Dict$RBNode_elm_builtin, color, key, value, left, right);
			}
		}
	});
var $elm$core$Basics$compare = _Utils_compare;
var $elm$core$Dict$insertHelp = F3(
	function (key, value, dict) {
		if (dict.$ === -2) {
			return A5($elm$core$Dict$RBNode_elm_builtin, 0, key, value, $elm$core$Dict$RBEmpty_elm_builtin, $elm$core$Dict$RBEmpty_elm_builtin);
		} else {
			var nColor = dict.a;
			var nKey = dict.b;
			var nValue = dict.c;
			var nLeft = dict.d;
			var nRight = dict.e;
			var _v1 = A2($elm$core$Basics$compare, key, nKey);
			switch (_v1) {
				case 0:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						A3($elm$core$Dict$insertHelp, key, value, nLeft),
						nRight);
				case 1:
					return A5($elm$core$Dict$RBNode_elm_builtin, nColor, nKey, value, nLeft, nRight);
				default:
					return A5(
						$elm$core$Dict$balance,
						nColor,
						nKey,
						nValue,
						nLeft,
						A3($elm$core$Dict$insertHelp, key, value, nRight));
			}
		}
	});
var $elm$core$Dict$insert = F3(
	function (key, value, dict) {
		var _v0 = A3($elm$core$Dict$insertHelp, key, value, dict);
		if ((_v0.$ === -1) && (!_v0.a)) {
			var _v1 = _v0.a;
			var k = _v0.b;
			var v = _v0.c;
			var l = _v0.d;
			var r = _v0.e;
			return A5($elm$core$Dict$RBNode_elm_builtin, 1, k, v, l, r);
		} else {
			var x = _v0;
			return x;
		}
	});
var $elm$core$Dict$union = F2(
	function (t1, t2) {
		return A3($elm$core$Dict$foldl, $elm$core$Dict$insert, t2, t1);
	});
var $stil4m$elm_syntax$Elm$Processing$addDependency = F2(
	function (dep, _v0) {
		var x = _v0;
		return A2($elm$core$Dict$union, dep.M, x);
	});
var $stil4m$elm_syntax$Elm$Interface$Operator = function (a) {
	return {$: 3, a: a};
};
var $stil4m$elm_syntax$Elm$Syntax$Range$empty = {
	w: {p: 0, t: 0},
	z: {p: 0, t: 0}
};
var $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange = $stil4m$elm_syntax$Elm$Syntax$Range$empty;
var $elm$core$Dict$empty = $elm$core$Dict$RBEmpty_elm_builtin;
var $elm$core$Dict$fromList = function (assocs) {
	return A3(
		$elm$core$List$foldl,
		F2(
			function (_v0, dict) {
				var key = _v0.a;
				var value = _v0.b;
				return A3($elm$core$Dict$insert, key, value, dict);
			}),
		$elm$core$Dict$empty,
		assocs);
};
var $author$project$Dependencies$elmCore = {
	M: $elm$core$Dict$fromList(
		_List_fromArray(
			[
				_Utils_Tuple2(
				_List_fromArray(
					['Basics']),
				_List_fromArray(
					[
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'apL'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '<|'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'apR'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '|>'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'or'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '||'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'and'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '&&'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 3)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'eq'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '=='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'neq'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '/='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'lt'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '<'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'gt'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '>'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'le'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '<='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 2),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'ge'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '>='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 4)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'append'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '++'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 5)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'add'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '+'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 6)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'sub'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '-'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 6)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'mul'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '*'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 7)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'fdiv'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '/'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 7)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'idiv'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '//'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 7)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'pow'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '^'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 8)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'composeL'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '<<'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 9)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'composeR'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '>>'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 9)
						})
					])),
				_Utils_Tuple2(
				_List_fromArray(
					['List']),
				_List_fromArray(
					[
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'cons'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '::'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 5)
						})
					]))
			])),
	N: 'elm/core',
	P: '1.0.0'
};
var $author$project$Dependencies$elmParser = {
	M: $elm$core$Dict$fromList(
		_List_fromArray(
			[
				_Utils_Tuple2(
				_List_fromArray(
					['Parser']),
				_List_fromArray(
					[
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'keeper'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '|='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 5)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'ignorer'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '|.'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 6)
						})
					])),
				_Utils_Tuple2(
				_List_fromArray(
					['Parser', 'Advanced']),
				_List_fromArray(
					[
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'keeper'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '|='),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 5)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'ignorer'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '|.'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 6)
						})
					]))
			])),
	N: 'elm/parser',
	P: '1.0.0'
};
var $author$project$Dependencies$elmUrl = {
	M: $elm$core$Dict$fromList(
		_List_fromArray(
			[
				_Utils_Tuple2(
				_List_fromArray(
					['Url', 'Parser']),
				_List_fromArray(
					[
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 1),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'slash'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '</>'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 7)
						}),
						$stil4m$elm_syntax$Elm$Interface$Operator(
						{
							e: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 0),
							f: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 'questionMark'),
							h: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, '<?>'),
							i: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Elm$Syntax$Range$emptyRange, 8)
						})
					]))
			])),
	N: 'elm/url',
	P: '1.0.0'
};
var $stil4m$elm_syntax$Elm$Processing$init = $elm$core$Dict$empty;
var $author$project$ParseMain$elmProcessContext = A2(
	$stil4m$elm_syntax$Elm$Processing$addDependency,
	$author$project$Dependencies$elmParser,
	A2(
		$stil4m$elm_syntax$Elm$Processing$addDependency,
		$author$project$Dependencies$elmUrl,
		A2($stil4m$elm_syntax$Elm$Processing$addDependency, $author$project$Dependencies$elmCore, $stil4m$elm_syntax$Elm$Processing$init)));
var $stil4m$elm_syntax$Elm$Internal$RawFile$Raw = $elm$core$Basics$identity;
var $stil4m$elm_syntax$Elm$Internal$RawFile$fromFile = $elm$core$Basics$identity;
var $elm$core$Result$map = F2(
	function (func, ra) {
		if (!ra.$) {
			var a = ra.a;
			return $elm$core$Result$Ok(
				func(a));
		} else {
			var e = ra.a;
			return $elm$core$Result$Err(e);
		}
	});
var $stil4m$elm_syntax$Rope$empty = $elm$core$Maybe$Nothing;
var $stil4m$elm_syntax$Elm$Syntax$Node$combine = F3(
	function (f, a, b) {
		var start = a.a.z;
		var end = b.a.w;
		return A2(
			$stil4m$elm_syntax$Elm$Syntax$Node$Node,
			{w: end, z: start},
			A2(f, a, b));
	});
var $stil4m$elm_syntax$ParserFast$Done = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$ParserFast$Loop = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$ParserFast$Bad = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$ExpectingAnyChar = F2(
	function (a, b) {
		return {$: 2, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$Good = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$Parser = $elm$core$Basics$identity;
var $elm$core$String$any = _String_any;
var $elm$core$Basics$isNaN = _Basics_isNaN;
var $stil4m$elm_syntax$Char$Extra$isUtf16Surrogate = function (c) {
	return $elm$core$Basics$isNaN(
		$elm$core$Char$toCode(c));
};
var $stil4m$elm_syntax$ParserFast$charStringIsUtf16HighSurrogate = function (charString) {
	return A2($elm$core$String$any, $stil4m$elm_syntax$Char$Extra$isUtf16Surrogate, charString);
};
var $elm$core$String$slice = _String_slice;
var $stil4m$elm_syntax$ParserFast$charOrEnd = F2(
	function (offset, string) {
		var actualChar = A3($elm$core$String$slice, offset, offset + 1, string);
		switch (actualChar) {
			case '\n':
				return -2;
			case '':
				return -1;
			default:
				return $stil4m$elm_syntax$ParserFast$charStringIsUtf16HighSurrogate(actualChar) ? (offset + 2) : (offset + 1);
		}
	});
var $stil4m$elm_syntax$ParserFast$skipWhileHelp = F6(
	function (isGood, offset, row, col, src, indent) {
		skipWhileHelp:
		while (true) {
			var actualChar = A3($elm$core$String$slice, offset, offset + 1, src);
			if (A2($elm$core$String$any, isGood, actualChar)) {
				if (actualChar === '\n') {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$src = src,
						$temp$indent = indent;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileHelp;
				} else {
					var $temp$isGood = isGood,
						$temp$offset = offset + 1,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileHelp;
				}
			} else {
				if ($stil4m$elm_syntax$ParserFast$charStringIsUtf16HighSurrogate(actualChar) && A2(
					$elm$core$String$any,
					isGood,
					A3($elm$core$String$slice, offset, offset + 2, src))) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 2,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileHelp;
				} else {
					return {S: col, g: indent, c: offset, t: row, b: src};
				}
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$anyCharFollowedByWhileMap = F2(
	function (consumedStringToRes, afterFirstIsOkay) {
		return function (s) {
			var firstOffset = A2($stil4m$elm_syntax$ParserFast$charOrEnd, s.c, s.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingAnyChar, s.t, s.S));
			} else {
				var s1 = _Utils_eq(firstOffset, -2) ? A6($stil4m$elm_syntax$ParserFast$skipWhileHelp, afterFirstIsOkay, s.c + 1, s.t + 1, 1, s.b, s.g) : A6($stil4m$elm_syntax$ParserFast$skipWhileHelp, afterFirstIsOkay, firstOffset, s.t, s.S + 1, s.b, s.g);
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					consumedStringToRes(
						A3($elm$core$String$slice, s.c, s1.c, s.b)),
					s1);
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$loopHelp = F5(
	function (committedSoFar, state, element, reduce, s0) {
		loopHelp:
		while (true) {
			var parseElement = element;
			var _v0 = parseElement(s0);
			if (!_v0.$) {
				var step = _v0.a;
				var s1 = _v0.b;
				var _v1 = A2(reduce, step, state);
				if (!_v1.$) {
					var newState = _v1.a;
					var $temp$committedSoFar = true,
						$temp$state = newState,
						$temp$element = element,
						$temp$reduce = reduce,
						$temp$s0 = s1;
					committedSoFar = $temp$committedSoFar;
					state = $temp$state;
					element = $temp$element;
					reduce = $temp$reduce;
					s0 = $temp$s0;
					continue loopHelp;
				} else {
					var result = _v1.a;
					return A2($stil4m$elm_syntax$ParserFast$Good, result, s1);
				}
			} else {
				var elementCommitted = _v0.a;
				var x = _v0.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committedSoFar || elementCommitted, x);
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$loop = F3(
	function (state, element, reduce) {
		return function (s) {
			return A5($stil4m$elm_syntax$ParserFast$loopHelp, false, state, element, reduce, s);
		};
	});
var $stil4m$elm_syntax$ParserFast$map2WithRange = F3(
	function (func, _v0, _v1) {
		var parseA = _v0;
		var parseB = _v1;
		return function (s0) {
			var _v2 = parseA(s0);
			if (_v2.$ === 1) {
				var committed = _v2.a;
				var x = _v2.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v2.a;
				var s1 = _v2.b;
				var _v3 = parseB(s1);
				if (_v3.$ === 1) {
					var x = _v3.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v3.a;
					var s2 = _v3.b;
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						A3(
							func,
							{
								w: {p: s2.S, t: s2.t},
								z: {p: s0.S, t: s0.t}
							},
							a,
							b),
						s2);
				}
			}
		};
	});
var $elm$core$Basics$neq = _Utils_notEqual;
var $elm$core$Basics$not = _Basics_not;
var $stil4m$elm_syntax$ParserFast$ExpectingOneOf = F3(
	function (a, b, c) {
		return {$: 7, a: a, b: b, c: c};
	});
var $stil4m$elm_syntax$ParserFast$oneOf2 = F2(
	function (_v0, _v1) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		return function (s) {
			var _v2 = attemptFirst(s);
			if (!_v2.$) {
				var firstGood = _v2;
				return firstGood;
			} else {
				var firstBad = _v2;
				var firstCommitted = firstBad.a;
				var firstX = firstBad.b;
				if (firstCommitted) {
					return firstBad;
				} else {
					var _v3 = attemptSecond(s);
					if (!_v3.$) {
						var secondGood = _v3;
						return secondGood;
					} else {
						var secondBad = _v3;
						var secondCommitted = secondBad.a;
						var secondX = secondBad.b;
						return secondCommitted ? secondBad : A2(
							$stil4m$elm_syntax$ParserFast$Bad,
							false,
							A3($stil4m$elm_syntax$ParserFast$ExpectingOneOf, firstX, secondX, _List_Nil));
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$oneOf3 = F3(
	function (_v0, _v1, _v2) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		var attemptThird = _v2;
		return function (s) {
			var _v3 = attemptFirst(s);
			if (!_v3.$) {
				var firstGood = _v3;
				return firstGood;
			} else {
				var firstBad = _v3;
				var firstCommitted = firstBad.a;
				var firstX = firstBad.b;
				if (firstCommitted) {
					return firstBad;
				} else {
					var _v4 = attemptSecond(s);
					if (!_v4.$) {
						var secondGood = _v4;
						return secondGood;
					} else {
						var secondBad = _v4;
						var secondCommitted = secondBad.a;
						var secondX = secondBad.b;
						if (secondCommitted) {
							return secondBad;
						} else {
							var _v5 = attemptThird(s);
							if (!_v5.$) {
								var thirdGood = _v5;
								return thirdGood;
							} else {
								var thirdBad = _v5;
								var thirdCommitted = thirdBad.a;
								var thirdX = thirdBad.b;
								return thirdCommitted ? thirdBad : A2(
									$stil4m$elm_syntax$ParserFast$Bad,
									false,
									A3(
										$stil4m$elm_syntax$ParserFast$ExpectingOneOf,
										firstX,
										secondX,
										_List_fromArray(
											[thirdX])));
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$ExpectingSymbol = F3(
	function (a, b, c) {
		return {$: 1, a: a, b: b, c: c};
	});
var $elm$core$String$length = _String_length;
var $stil4m$elm_syntax$ParserFast$symbol = F2(
	function (str, res) {
		var strLength = $elm$core$String$length(str);
		return function (s) {
			var newOffset = s.c + strLength;
			return _Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				str + '') ? A2(
				$stil4m$elm_syntax$ParserFast$Good,
				res,
				{S: s.S + strLength, g: s.g, c: newOffset, t: s.t, b: s.b}) : A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s.t, s.S, str));
		};
	});
var $stil4m$elm_syntax$ParserFast$pStepCommit = function (pStep) {
	if (!pStep.$) {
		var good = pStep;
		return good;
	} else {
		var x = pStep.b;
		return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
	}
};
var $stil4m$elm_syntax$ParserFast$symbolFollowedBy = F2(
	function (str, _v0) {
		var parseNext = _v0;
		var strLength = $elm$core$String$length(str);
		return function (s) {
			var newOffset = s.c + strLength;
			return _Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				str + '') ? $stil4m$elm_syntax$ParserFast$pStepCommit(
				parseNext(
					{S: s.S + strLength, g: s.g, c: newOffset, t: s.t, b: s.b})) : A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s.t, s.S, str));
		};
	});
var $stil4m$elm_syntax$ParserFast$while = function (isGood) {
	return function (s0) {
		var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileHelp, isGood, s0.c, s0.t, s0.S, s0.b, s0.g);
		return A2(
			$stil4m$elm_syntax$ParserFast$Good,
			A3($elm$core$String$slice, s0.c, s1.c, s0.b),
			s1);
	};
};
var $stil4m$elm_syntax$ParserFast$nestableMultiCommentMapWithRange = F3(
	function (rangeContentToRes, _v0, _v1) {
		var openChar = _v0.a;
		var openTail = _v0.b;
		var closeChar = _v1.a;
		var closeTail = _v1.b;
		var open = A2($elm$core$String$cons, openChar, openTail);
		var isNotRelevant = function (_char) {
			return (!_Utils_eq(_char, openChar)) && ((!_Utils_eq(_char, closeChar)) && (!$stil4m$elm_syntax$Char$Extra$isUtf16Surrogate(_char)));
		};
		var close = A2($elm$core$String$cons, closeChar, closeTail);
		return A3(
			$stil4m$elm_syntax$ParserFast$map2WithRange,
			F3(
				function (range, afterOpen, contentAfterAfterOpen) {
					return A2(
						rangeContentToRes,
						range,
						_Utils_ap(
							open,
							_Utils_ap(
								afterOpen,
								_Utils_ap(contentAfterAfterOpen, close))));
				}),
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				open,
				$stil4m$elm_syntax$ParserFast$while(isNotRelevant)),
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				A2($stil4m$elm_syntax$ParserFast$symbol, close, ''),
				A3(
					$stil4m$elm_syntax$ParserFast$loop,
					_Utils_Tuple2('', 1),
					A3(
						$stil4m$elm_syntax$ParserFast$oneOf3,
						A2(
							$stil4m$elm_syntax$ParserFast$symbol,
							close,
							_Utils_Tuple2(close, -1)),
						A2(
							$stil4m$elm_syntax$ParserFast$symbol,
							open,
							_Utils_Tuple2(open, 1)),
						A2(
							$stil4m$elm_syntax$ParserFast$anyCharFollowedByWhileMap,
							function (consumed) {
								return _Utils_Tuple2(consumed, 0);
							},
							isNotRelevant)),
					F2(
						function (_v2, _v3) {
							var toAppend = _v2.a;
							var nestingChange = _v2.b;
							var soFarContent = _v3.a;
							var soFarNesting = _v3.b;
							var newNesting = soFarNesting + nestingChange;
							return (!newNesting) ? $stil4m$elm_syntax$ParserFast$Done(soFarContent) : $stil4m$elm_syntax$ParserFast$Loop(
								_Utils_Tuple2(soFarContent + (toAppend + ''), newNesting));
						}))));
	});
var $stil4m$elm_syntax$Elm$Parser$Comments$multiLineCommentNoCheck = A3(
	$stil4m$elm_syntax$ParserFast$nestableMultiCommentMapWithRange,
	$stil4m$elm_syntax$Elm$Syntax$Node$Node,
	_Utils_Tuple2('{', '-'),
	_Utils_Tuple2('-', '}'));
var $stil4m$elm_syntax$Elm$Parser$Comments$declarationDocumentation = $stil4m$elm_syntax$Elm$Parser$Comments$multiLineCommentNoCheck;
var $stil4m$elm_syntax$Rope$Branch2 = F2(
	function (a, b) {
		return {$: 1, a: a, b: b};
	});
var $stil4m$elm_syntax$Rope$filledPrependTo = F2(
	function (right, leftLikelyFilled) {
		if (right.$ === 1) {
			return $elm$core$Maybe$Just(leftLikelyFilled);
		} else {
			var rightLikelyFilled = right.a;
			return $elm$core$Maybe$Just(
				A2($stil4m$elm_syntax$Rope$Branch2, leftLikelyFilled, rightLikelyFilled));
		}
	});
var $stil4m$elm_syntax$Elm$Parser$Declarations$FunctionDeclarationAfterDocumentation = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Expression$ExtendRightByOperation = $elm$core$Basics$identity;
var $stil4m$elm_syntax$Elm$Parser$Expression$FieldsFirstValue = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Expression$RecordUpdateFirstSetter = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Expression$TupledParenthesizedFollowedByRecordAccesses = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Expression$TupledTwoOrThree = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Tokens$isAllowedOperatorToken = function (operatorCandidateToValidate) {
	switch (operatorCandidateToValidate) {
		case '==':
			return true;
		case '/=':
			return true;
		case '::':
			return true;
		case '++':
			return true;
		case '+':
			return true;
		case '*':
			return true;
		case '<|':
			return true;
		case '|>':
			return true;
		case '||':
			return true;
		case '<=':
			return true;
		case '>=':
			return true;
		case '|=':
			return true;
		case '|.':
			return true;
		case '//':
			return true;
		case '</>':
			return true;
		case '<?>':
			return true;
		case '^':
			return true;
		case '<<':
			return true;
		case '>>':
			return true;
		case '<':
			return true;
		case '>':
			return true;
		case '/':
			return true;
		case '&&':
			return true;
		case '-':
			return true;
		default:
			return false;
	}
};
var $stil4m$elm_syntax$Elm$Parser$Tokens$isOperatorSymbolChar = function (c) {
	switch (c) {
		case '+':
			return true;
		case '-':
			return true;
		case '/':
			return true;
		case '*':
			return true;
		case '=':
			return true;
		case '.':
			return true;
		case '<':
			return true;
		case '>':
			return true;
		case ':':
			return true;
		case '&':
			return true;
		case '|':
			return true;
		case '^':
			return true;
		case '?':
			return true;
		default:
			return false;
	}
};
var $stil4m$elm_syntax$ParserFast$ExpectingStringSatisfyingPredicate = F2(
	function (a, b) {
		return {$: 5, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakAnd2PartUtf16Help = F3(
	function (isGood, offset, src) {
		skipWhileWithoutLinebreakAnd2PartUtf16Help:
		while (true) {
			if (A2(
				$elm$core$String$any,
				isGood,
				A3($elm$core$String$slice, offset, offset + 1, src))) {
				var $temp$isGood = isGood,
					$temp$offset = offset + 1,
					$temp$src = src;
				isGood = $temp$isGood;
				offset = $temp$offset;
				src = $temp$src;
				continue skipWhileWithoutLinebreakAnd2PartUtf16Help;
			} else {
				return offset;
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$whileWithoutLinebreakAnd2PartUtf16ValidateMapWithRangeBacktrackableFollowedBySymbol = F4(
	function (whileRangeAndContentToRes, whileCharIsOkay, whileResultIsOkay, mandatoryFinalSymbol) {
		var mandatoryFinalSymbolLength = $elm$core$String$length(mandatoryFinalSymbol);
		return function (s0) {
			var s1Offset = A3($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakAnd2PartUtf16Help, whileCharIsOkay, s0.c, s0.b);
			var whileContent = A3($elm$core$String$slice, s0.c, s1Offset, s0.b);
			if (_Utils_eq(
				A3($elm$core$String$slice, s1Offset, s1Offset + mandatoryFinalSymbolLength, s0.b),
				mandatoryFinalSymbol + '') && whileResultIsOkay(whileContent)) {
				var s1Column = s0.S + (s1Offset - s0.c);
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A2(
						whileRangeAndContentToRes,
						{
							w: {p: s1Column, t: s0.t},
							z: {p: s0.S, t: s0.t}
						},
						whileContent),
					{S: s1Column + mandatoryFinalSymbolLength, g: s0.g, c: s1Offset + mandatoryFinalSymbolLength, t: s0.t, b: s0.b});
			} else {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingStringSatisfyingPredicate, s0.t, s0.S + 1));
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$allowedPrefixOperatorFollowedByClosingParensOneOf = A4(
	$stil4m$elm_syntax$ParserFast$whileWithoutLinebreakAnd2PartUtf16ValidateMapWithRangeBacktrackableFollowedBySymbol,
	F2(
		function (operatorRange, operator) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					{
						w: {p: operatorRange.w.p + 1, t: operatorRange.w.t},
						z: {p: operatorRange.z.p - 1, t: operatorRange.z.t}
					},
					$stil4m$elm_syntax$Elm$Syntax$Expression$PrefixOperator(operator))
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$isOperatorSymbolChar,
	$stil4m$elm_syntax$Elm$Parser$Tokens$isAllowedOperatorToken,
	')');
var $stil4m$elm_syntax$Elm$Parser$Expression$applyExtensionRight = F2(
	function (_v0, leftNode) {
		var operation = _v0;
		var leftRange = leftNode.a;
		var rightExpressionNode = operation.E;
		var rightExpressionRange = rightExpressionNode.a;
		return A2(
			$stil4m$elm_syntax$Elm$Syntax$Node$Node,
			{w: rightExpressionRange.w, z: leftRange.z},
			A4($stil4m$elm_syntax$Elm$Syntax$Expression$OperatorApplication, operation.u, operation.e, leftNode, rightExpressionNode));
	});
var $stil4m$elm_syntax$ParserFast$anyChar = function (s) {
	var newOffset = A2($stil4m$elm_syntax$ParserFast$charOrEnd, s.c, s.b);
	if (_Utils_eq(newOffset, -1)) {
		return A2(
			$stil4m$elm_syntax$ParserFast$Bad,
			false,
			A2($stil4m$elm_syntax$ParserFast$ExpectingAnyChar, s.t, s.S));
	} else {
		if (_Utils_eq(newOffset, -2)) {
			return A2(
				$stil4m$elm_syntax$ParserFast$Good,
				'\n',
				{S: 1, g: s.g, c: s.c + 1, t: s.t + 1, b: s.b});
		} else {
			var _v0 = $elm$core$String$toList(
				A3($elm$core$String$slice, s.c, newOffset, s.b));
			if (!_v0.b) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingAnyChar, s.t, s.S));
			} else {
				var c = _v0.a;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					c,
					{S: s.S + 1, g: s.g, c: newOffset, t: s.t, b: s.b});
			}
		}
	}
};
var $stil4m$elm_syntax$ParserFast$followedBySymbol = F2(
	function (str, _v0) {
		var parsePrevious = _v0;
		var strLength = $elm$core$String$length(str);
		return function (s0) {
			var _v1 = parsePrevious(s0);
			if (!_v1.$) {
				var res = _v1.a;
				var s1 = _v1.b;
				var newOffset = s1.c + strLength;
				return _Utils_eq(
					A3($elm$core$String$slice, s1.c, newOffset, s1.b),
					str + '') ? A2(
					$stil4m$elm_syntax$ParserFast$Good,
					res,
					{S: s1.S + strLength, g: s1.g, c: newOffset, t: s1.t, b: s1.b}) : A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					true,
					A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s1.t, s1.S, str));
			} else {
				var bad = _v1;
				return bad;
			}
		};
	});
var $elm$core$Char$fromCode = _Char_fromCode;
var $stil4m$elm_syntax$Elm$Parser$Tokens$charToHex = function (c) {
	switch (c) {
		case '0':
			return 0;
		case '1':
			return 1;
		case '2':
			return 2;
		case '3':
			return 3;
		case '4':
			return 4;
		case '5':
			return 5;
		case '6':
			return 6;
		case '7':
			return 7;
		case '8':
			return 8;
		case '9':
			return 9;
		case 'a':
			return 10;
		case 'b':
			return 11;
		case 'c':
			return 12;
		case 'd':
			return 13;
		case 'e':
			return 14;
		case 'f':
			return 15;
		case 'A':
			return 10;
		case 'B':
			return 11;
		case 'C':
			return 12;
		case 'D':
			return 13;
		case 'E':
			return 14;
		default:
			return 15;
	}
};
var $elm$core$Basics$pow = _Basics_pow;
var $stil4m$elm_syntax$Elm$Parser$Tokens$hexStringToInt = function (string) {
	return A3(
		$elm$core$String$foldr,
		F2(
			function (c, soFar) {
				return {
					D: soFar.D + 1,
					I: soFar.I + (A2($elm$core$Basics$pow, 16, soFar.D) * $stil4m$elm_syntax$Elm$Parser$Tokens$charToHex(c))
				};
			}),
		{D: 0, I: 0},
		string).I;
};
var $stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate = F2(
	function (a, b) {
		return {$: 4, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak = F3(
	function (predicate, offset, string) {
		var actualChar = A3($elm$core$String$slice, offset, offset + 1, string);
		return A2($elm$core$String$any, predicate, actualChar) ? (offset + 1) : (($stil4m$elm_syntax$ParserFast$charStringIsUtf16HighSurrogate(actualChar) && A2(
			$elm$core$String$any,
			predicate,
			A3($elm$core$String$slice, offset, offset + 2, string))) ? (offset + 2) : (-1));
	});
var $stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp = F6(
	function (isGood, offset, row, col, src, indent) {
		skipWhileWithoutLinebreakHelp:
		while (true) {
			var actualChar = A3($elm$core$String$slice, offset, offset + 1, src);
			if (A2($elm$core$String$any, isGood, actualChar)) {
				var $temp$isGood = isGood,
					$temp$offset = offset + 1,
					$temp$row = row,
					$temp$col = col + 1,
					$temp$src = src,
					$temp$indent = indent;
				isGood = $temp$isGood;
				offset = $temp$offset;
				row = $temp$row;
				col = $temp$col;
				src = $temp$src;
				indent = $temp$indent;
				continue skipWhileWithoutLinebreakHelp;
			} else {
				if ($stil4m$elm_syntax$ParserFast$charStringIsUtf16HighSurrogate(actualChar) && A2(
					$elm$core$String$any,
					isGood,
					A3($elm$core$String$slice, offset, offset + 2, src))) {
					var $temp$isGood = isGood,
						$temp$offset = offset + 2,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent;
					isGood = $temp$isGood;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileWithoutLinebreakHelp;
				} else {
					return {S: col, g: indent, c: offset, t: row, b: src};
				}
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$ifFollowedByWhileMapWithoutLinebreak = F3(
	function (consumedStringToRes, firstIsOkay, afterFirstIsOkay) {
		return function (s0) {
			var firstOffset = A3($stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak, firstIsOkay, s0.c, s0.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate, s0.t, s0.S));
			} else {
				var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, afterFirstIsOkay, firstOffset, s0.t, s0.S + 1, s0.b, s0.g);
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					consumedStringToRes(
						A3($elm$core$String$slice, s0.c, s1.c, s0.b)),
					s1);
			}
		};
	});
var $elm$core$Char$isHexDigit = function (_char) {
	var code = $elm$core$Char$toCode(_char);
	return ((48 <= code) && (code <= 57)) || (((65 <= code) && (code <= 70)) || ((97 <= code) && (code <= 102)));
};
var $stil4m$elm_syntax$ParserFast$oneOf7 = F7(
	function (_v0, _v1, _v2, _v3, _v4, _v5, _v6) {
		var attempt0 = _v0;
		var attempt1 = _v1;
		var attempt2 = _v2;
		var attempt3 = _v3;
		var attempt4 = _v4;
		var attempt5 = _v5;
		var attempt6 = _v6;
		return function (s) {
			var _v7 = attempt0(s);
			if (!_v7.$) {
				var good = _v7;
				return good;
			} else {
				var bad0 = _v7;
				var committed0 = bad0.a;
				var x0 = bad0.b;
				if (committed0) {
					return bad0;
				} else {
					var _v8 = attempt1(s);
					if (!_v8.$) {
						var good = _v8;
						return good;
					} else {
						var bad1 = _v8;
						var committed1 = bad1.a;
						var x1 = bad1.b;
						if (committed1) {
							return bad1;
						} else {
							var _v9 = attempt2(s);
							if (!_v9.$) {
								var good = _v9;
								return good;
							} else {
								var bad2 = _v9;
								var committed2 = bad2.a;
								var x2 = bad2.b;
								if (committed2) {
									return bad2;
								} else {
									var _v10 = attempt3(s);
									if (!_v10.$) {
										var good = _v10;
										return good;
									} else {
										var bad3 = _v10;
										var committed3 = bad3.a;
										var x3 = bad3.b;
										if (committed3) {
											return bad3;
										} else {
											var _v11 = attempt4(s);
											if (!_v11.$) {
												var good = _v11;
												return good;
											} else {
												var bad4 = _v11;
												var committed4 = bad4.a;
												var x4 = bad4.b;
												if (committed4) {
													return bad4;
												} else {
													var _v12 = attempt5(s);
													if (!_v12.$) {
														var good = _v12;
														return good;
													} else {
														var bad5 = _v12;
														var committed5 = bad5.a;
														var x5 = bad5.b;
														if (committed5) {
															return bad5;
														} else {
															var _v13 = attempt6(s);
															if (!_v13.$) {
																var good = _v13;
																return good;
															} else {
																var bad6 = _v13;
																var committed6 = bad6.a;
																var x6 = bad6.b;
																return committed6 ? bad6 : A2(
																	$stil4m$elm_syntax$ParserFast$Bad,
																	false,
																	A3(
																		$stil4m$elm_syntax$ParserFast$ExpectingOneOf,
																		x0,
																		x1,
																		_List_fromArray(
																			[x2, x3, x4, x5, x6])));
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$escapedCharValueMap = function (charToRes) {
	return A7(
		$stil4m$elm_syntax$ParserFast$oneOf7,
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'\'',
			charToRes('\'')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'\"',
			charToRes('\"')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'n',
			charToRes('\n')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			't',
			charToRes('\t')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'r',
			charToRes('\u000D')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'\\',
			charToRes('\\')),
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'u{',
			A2(
				$stil4m$elm_syntax$ParserFast$followedBySymbol,
				'}',
				A3(
					$stil4m$elm_syntax$ParserFast$ifFollowedByWhileMapWithoutLinebreak,
					function (hex) {
						return charToRes(
							$elm$core$Char$fromCode(
								$stil4m$elm_syntax$Elm$Parser$Tokens$hexStringToInt(hex)));
					},
					$elm$core$Char$isHexDigit,
					$elm$core$Char$isHexDigit))));
};
var $stil4m$elm_syntax$ParserFast$oneOf2MapWithStartRowColumnAndEndRowColumn = F4(
	function (firstToChoice, _v0, secondToChoice, _v1) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		return function (s) {
			var _v2 = attemptFirst(s);
			if (!_v2.$) {
				var first = _v2.a;
				var s1 = _v2.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A5(firstToChoice, s.t, s.S, first, s1.t, s1.S),
					s1);
			} else {
				var firstCommitted = _v2.a;
				var firstX = _v2.b;
				if (firstCommitted) {
					return A2($stil4m$elm_syntax$ParserFast$Bad, firstCommitted, firstX);
				} else {
					var _v3 = attemptSecond(s);
					if (!_v3.$) {
						var second = _v3.a;
						var s1 = _v3.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A5(secondToChoice, s.t, s.S, second, s1.t, s1.S),
							s1);
					} else {
						var secondCommitted = _v3.a;
						var secondX = _v3.b;
						return secondCommitted ? A2($stil4m$elm_syntax$ParserFast$Bad, secondCommitted, secondX) : A2(
							$stil4m$elm_syntax$ParserFast$Bad,
							false,
							A3($stil4m$elm_syntax$ParserFast$ExpectingOneOf, firstX, secondX, _List_Nil));
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$characterLiteralMapWithRange = function (rangeAndCharToRes) {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'\'',
		A2(
			$stil4m$elm_syntax$ParserFast$followedBySymbol,
			'\'',
			A4(
				$stil4m$elm_syntax$ParserFast$oneOf2MapWithStartRowColumnAndEndRowColumn,
				F5(
					function (startRow, startColumn, _char, endRow, endColumn) {
						return A2(
							rangeAndCharToRes,
							{
								w: {p: endColumn + 1, t: endRow},
								z: {p: startColumn - 1, t: startRow}
							},
							_char);
					}),
				A2(
					$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
					'\\',
					$stil4m$elm_syntax$Elm$Parser$Tokens$escapedCharValueMap($elm$core$Basics$identity)),
				F5(
					function (startRow, startColumn, _char, endRow, endColumn) {
						return A2(
							rangeAndCharToRes,
							{
								w: {p: endColumn + 1, t: endRow},
								z: {p: startColumn - 1, t: startRow}
							},
							_char);
					}),
				$stil4m$elm_syntax$ParserFast$anyChar)));
};
var $stil4m$elm_syntax$Elm$Parser$Expression$charLiteralExpression = $stil4m$elm_syntax$Elm$Parser$Tokens$characterLiteralMapWithRange(
	F2(
		function (range, _char) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Expression$CharLiteral(_char))
			};
		}));
var $stil4m$elm_syntax$Elm$Parser$Expression$errUnknownInfixOperator = $elm$core$Result$Err('unknown infix operator');
var $stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateMapWithRangeWithoutLinebreak = F4(
	function (toResult, firstIsOkay, afterFirstIsOkay, resultIsOkay) {
		return function (s0) {
			var firstOffset = A3($stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak, firstIsOkay, s0.c, s0.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate, s0.t, s0.S));
			} else {
				var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, afterFirstIsOkay, firstOffset, s0.t, s0.S + 1, s0.b, s0.g);
				var name = A3($elm$core$String$slice, s0.c, s1.c, s0.b);
				return resultIsOkay(name) ? A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A2(
						toResult,
						{
							w: {p: s1.S, t: s1.t},
							z: {p: s0.S, t: s0.t}
						},
						name),
					s1) : A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingStringSatisfyingPredicate, s0.t, s0.S + 1));
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$isNotReserved = function (name) {
	switch (name) {
		case 'module':
			return false;
		case 'exposing':
			return false;
		case 'import':
			return false;
		case 'as':
			return false;
		case 'if':
			return false;
		case 'then':
			return false;
		case 'else':
			return false;
		case 'let':
			return false;
		case 'in':
			return false;
		case 'case':
			return false;
		case 'of':
			return false;
		case 'port':
			return false;
		case 'type':
			return false;
		case 'where':
			return false;
		default:
			return true;
	}
};
var $stil4m$elm_syntax$Char$Extra$charCodeIsDigit = function (code) {
	return (code <= 57) && (48 <= code);
};
var $stil4m$elm_syntax$Char$Extra$charCodeIsLower = function (code) {
	return (97 <= code) && (code <= 122);
};
var $stil4m$elm_syntax$Char$Extra$charCodeIsUpper = function (code) {
	return (code <= 90) && (65 <= code);
};
var $elm$core$Basics$modBy = _Basics_modBy;
var $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast = function (c) {
	var code = $elm$core$Char$toCode(c);
	return $stil4m$elm_syntax$Char$Extra$charCodeIsLower(code) || ($stil4m$elm_syntax$Char$Extra$charCodeIsUpper(code) || ($stil4m$elm_syntax$Char$Extra$charCodeIsDigit(code) || ((code === 95) || (((code !== 32) && (code !== 10)) && ((code < 256) ? (((48 <= code) && (code <= 57)) || (((65 <= code) && (code <= 90)) || (((97 <= code) && (code <= 122)) || ((code === 170) || (((178 <= code) && (code <= 179)) || ((code === 181) || (((185 <= code) && (code <= 186)) || (((188 <= code) && (code <= 190)) || (((192 <= code) && (code <= 214)) || (((216 <= code) && (code <= 246)) || ((248 <= code) && (code <= 255)))))))))))) : ((code < 43700) ? ((code < 4347) ? ((code < 2868) ? ((code < 2364) ? ((code < 1648) ? ((code < 930) ? (((256 <= code) && (code <= 705)) || (((710 <= code) && (code <= 721)) || (((736 <= code) && (code <= 740)) || (((880 <= code) && (code <= 884)) || (((886 <= code) && (code <= 887)) || (((890 <= code) && (code <= 893)) || ((code === 895) || ((code === 902) || (((904 <= code) && (code <= 906)) || ((code === 908) || (((910 <= code) && (code <= 929)) || ((!A2($elm$core$Basics$modBy, 2, code)) && ((748 <= code) && (code <= 750)))))))))))))) : (((931 <= code) && (code <= 1013)) || (((1015 <= code) && (code <= 1153)) || (((1162 <= code) && (code <= 1327)) || (((1329 <= code) && (code <= 1366)) || ((code === 1369) || (((1376 <= code) && (code <= 1416)) || (((1488 <= code) && (code <= 1514)) || (((1519 <= code) && (code <= 1522)) || (((1568 <= code) && (code <= 1610)) || (((1632 <= code) && (code <= 1641)) || ((1646 <= code) && (code <= 1647))))))))))))) : ((code < 2041) ? (((1649 <= code) && (code <= 1747)) || ((code === 1749) || (((1765 <= code) && (code <= 1766)) || (((1774 <= code) && (code <= 1788)) || ((code === 1791) || ((code === 1808) || (((1810 <= code) && (code <= 1839)) || (((1869 <= code) && (code <= 1957)) || ((code === 1969) || (((1984 <= code) && (code <= 2026)) || ((2036 <= code) && (code <= 2037)))))))))))) : ((code === 2042) || (((2048 <= code) && (code <= 2069)) || ((code === 2074) || ((code === 2084) || ((code === 2088) || (((2112 <= code) && (code <= 2136)) || (((2144 <= code) && (code <= 2154)) || (((2160 <= code) && (code <= 2183)) || (((2185 <= code) && (code <= 2190)) || (((2208 <= code) && (code <= 2249)) || ((2308 <= code) && (code <= 2361)))))))))))))) : ((code < 2609) ? ((code < 2492) ? ((code === 2365) || ((code === 2384) || (((2392 <= code) && (code <= 2401)) || (((2406 <= code) && (code <= 2415)) || (((2417 <= code) && (code <= 2432)) || (((2437 <= code) && (code <= 2444)) || (((2447 <= code) && (code <= 2448)) || (((2451 <= code) && (code <= 2472)) || (((2474 <= code) && (code <= 2480)) || ((code === 2482) || ((2486 <= code) && (code <= 2489)))))))))))) : ((code === 2493) || ((code === 2510) || (((2524 <= code) && (code <= 2525)) || (((2527 <= code) && (code <= 2529)) || (((2534 <= code) && (code <= 2545)) || (((2548 <= code) && (code <= 2553)) || ((code === 2556) || (((2565 <= code) && (code <= 2570)) || (((2575 <= code) && (code <= 2576)) || (((2579 <= code) && (code <= 2600)) || ((2602 <= code) && (code <= 2608))))))))))))) : ((code < 2737) ? (((2610 <= code) && (code <= 2611)) || (((2613 <= code) && (code <= 2614)) || (((2616 <= code) && (code <= 2617)) || (((2649 <= code) && (code <= 2652)) || ((code === 2654) || (((2662 <= code) && (code <= 2671)) || (((2674 <= code) && (code <= 2676)) || (((2693 <= code) && (code <= 2701)) || (((2703 <= code) && (code <= 2705)) || (((2707 <= code) && (code <= 2728)) || ((2730 <= code) && (code <= 2736)))))))))))) : (((2738 <= code) && (code <= 2739)) || (((2741 <= code) && (code <= 2745)) || ((code === 2749) || ((code === 2768) || (((2784 <= code) && (code <= 2785)) || (((2790 <= code) && (code <= 2799)) || ((code === 2809) || (((2821 <= code) && (code <= 2828)) || (((2831 <= code) && (code <= 2832)) || (((2835 <= code) && (code <= 2856)) || (((2858 <= code) && (code <= 2864)) || ((2866 <= code) && (code <= 2867)))))))))))))))) : ((code < 3411) ? ((code < 3132) ? ((code < 2971) ? (((2869 <= code) && (code <= 2873)) || ((code === 2877) || (((2908 <= code) && (code <= 2909)) || (((2911 <= code) && (code <= 2913)) || (((2918 <= code) && (code <= 2927)) || (((2929 <= code) && (code <= 2935)) || ((code === 2947) || (((2949 <= code) && (code <= 2954)) || (((2958 <= code) && (code <= 2960)) || (((2962 <= code) && (code <= 2965)) || ((2969 <= code) && (code <= 2970)))))))))))) : ((code === 2972) || (((2974 <= code) && (code <= 2975)) || (((2979 <= code) && (code <= 2980)) || (((2984 <= code) && (code <= 2986)) || (((2990 <= code) && (code <= 3001)) || ((code === 3024) || (((3046 <= code) && (code <= 3058)) || (((3077 <= code) && (code <= 3084)) || (((3086 <= code) && (code <= 3088)) || (((3090 <= code) && (code <= 3112)) || ((3114 <= code) && (code <= 3129))))))))))))) : ((code < 3252) ? ((code === 3133) || (((3160 <= code) && (code <= 3162)) || ((code === 3165) || (((3168 <= code) && (code <= 3169)) || (((3174 <= code) && (code <= 3183)) || (((3192 <= code) && (code <= 3198)) || ((code === 3200) || (((3205 <= code) && (code <= 3212)) || (((3214 <= code) && (code <= 3216)) || (((3218 <= code) && (code <= 3240)) || ((3242 <= code) && (code <= 3251)))))))))))) : (((3253 <= code) && (code <= 3257)) || ((code === 3261) || (((3293 <= code) && (code <= 3294)) || (((3296 <= code) && (code <= 3297)) || (((3302 <= code) && (code <= 3311)) || (((3313 <= code) && (code <= 3314)) || (((3332 <= code) && (code <= 3340)) || (((3342 <= code) && (code <= 3344)) || (((3346 <= code) && (code <= 3386)) || ((code === 3389) || (code === 3406))))))))))))) : ((code < 3775) ? ((code < 3633) ? (((3412 <= code) && (code <= 3414)) || (((3416 <= code) && (code <= 3425)) || (((3430 <= code) && (code <= 3448)) || (((3450 <= code) && (code <= 3455)) || (((3461 <= code) && (code <= 3478)) || (((3482 <= code) && (code <= 3505)) || (((3507 <= code) && (code <= 3515)) || ((code === 3517) || (((3520 <= code) && (code <= 3526)) || (((3558 <= code) && (code <= 3567)) || ((3585 <= code) && (code <= 3632)))))))))))) : (((3634 <= code) && (code <= 3635)) || (((3648 <= code) && (code <= 3654)) || (((3664 <= code) && (code <= 3673)) || (((3713 <= code) && (code <= 3714)) || ((code === 3716) || (((3718 <= code) && (code <= 3722)) || (((3724 <= code) && (code <= 3747)) || ((code === 3749) || (((3751 <= code) && (code <= 3760)) || (((3762 <= code) && (code <= 3763)) || (code === 3773)))))))))))) : ((code < 4175) ? (((3776 <= code) && (code <= 3780)) || ((code === 3782) || (((3792 <= code) && (code <= 3801)) || (((3804 <= code) && (code <= 3807)) || ((code === 3840) || (((3872 <= code) && (code <= 3891)) || (((3904 <= code) && (code <= 3911)) || (((3913 <= code) && (code <= 3948)) || (((3976 <= code) && (code <= 3980)) || (((4096 <= code) && (code <= 4138)) || ((4159 <= code) && (code <= 4169)))))))))))) : (((4176 <= code) && (code <= 4181)) || (((4186 <= code) && (code <= 4189)) || ((code === 4193) || (((4197 <= code) && (code <= 4198)) || (((4206 <= code) && (code <= 4208)) || (((4213 <= code) && (code <= 4225)) || ((code === 4238) || (((4240 <= code) && (code <= 4249)) || (((4256 <= code) && (code <= 4293)) || ((code === 4295) || ((code === 4301) || ((4304 <= code) && (code <= 4346))))))))))))))))) : ((code < 8454) ? ((code < 6527) ? ((code < 5760) ? ((code < 4801) ? (((4348 <= code) && (code <= 4680)) || (((4682 <= code) && (code <= 4685)) || (((4688 <= code) && (code <= 4694)) || ((code === 4696) || (((4698 <= code) && (code <= 4701)) || (((4704 <= code) && (code <= 4744)) || (((4746 <= code) && (code <= 4749)) || (((4752 <= code) && (code <= 4784)) || (((4786 <= code) && (code <= 4789)) || (((4792 <= code) && (code <= 4798)) || (code === 4800))))))))))) : (((4802 <= code) && (code <= 4805)) || (((4808 <= code) && (code <= 4822)) || (((4824 <= code) && (code <= 4880)) || (((4882 <= code) && (code <= 4885)) || (((4888 <= code) && (code <= 4954)) || (((4969 <= code) && (code <= 4988)) || (((4992 <= code) && (code <= 5007)) || (((5024 <= code) && (code <= 5109)) || (((5112 <= code) && (code <= 5117)) || (((5121 <= code) && (code <= 5740)) || ((5743 <= code) && (code <= 5759))))))))))))) : ((code < 6111) ? (((5761 <= code) && (code <= 5786)) || (((5792 <= code) && (code <= 5866)) || (((5870 <= code) && (code <= 5880)) || (((5888 <= code) && (code <= 5905)) || (((5919 <= code) && (code <= 5937)) || (((5952 <= code) && (code <= 5969)) || (((5984 <= code) && (code <= 5996)) || (((5998 <= code) && (code <= 6000)) || (((6016 <= code) && (code <= 6067)) || ((code === 6103) || (code === 6108))))))))))) : (((6112 <= code) && (code <= 6121)) || (((6128 <= code) && (code <= 6137)) || (((6160 <= code) && (code <= 6169)) || (((6176 <= code) && (code <= 6264)) || (((6272 <= code) && (code <= 6276)) || (((6279 <= code) && (code <= 6312)) || ((code === 6314) || (((6320 <= code) && (code <= 6389)) || (((6400 <= code) && (code <= 6430)) || (((6470 <= code) && (code <= 6509)) || ((6512 <= code) && (code <= 6516)))))))))))))) : ((code < 7417) ? ((code < 7042) ? (((6528 <= code) && (code <= 6571)) || (((6576 <= code) && (code <= 6601)) || (((6608 <= code) && (code <= 6618)) || (((6656 <= code) && (code <= 6678)) || (((6688 <= code) && (code <= 6740)) || (((6784 <= code) && (code <= 6793)) || (((6800 <= code) && (code <= 6809)) || ((code === 6823) || (((6917 <= code) && (code <= 6963)) || (((6981 <= code) && (code <= 6988)) || ((6992 <= code) && (code <= 7001)))))))))))) : (((7043 <= code) && (code <= 7072)) || (((7086 <= code) && (code <= 7141)) || (((7168 <= code) && (code <= 7203)) || (((7232 <= code) && (code <= 7241)) || (((7245 <= code) && (code <= 7293)) || (((7296 <= code) && (code <= 7304)) || (((7312 <= code) && (code <= 7354)) || (((7357 <= code) && (code <= 7359)) || (((7401 <= code) && (code <= 7404)) || (((7406 <= code) && (code <= 7411)) || ((7413 <= code) && (code <= 7414))))))))))))) : ((code < 8129) ? ((code === 7418) || (((7424 <= code) && (code <= 7615)) || (((7680 <= code) && (code <= 7957)) || (((7960 <= code) && (code <= 7965)) || (((7968 <= code) && (code <= 8005)) || (((8008 <= code) && (code <= 8013)) || (((8016 <= code) && (code <= 8023)) || (((8032 <= code) && (code <= 8061)) || (((8064 <= code) && (code <= 8116)) || (((8118 <= code) && (code <= 8124)) || ((code === 8126) || ((A2($elm$core$Basics$modBy, 2, code) === 1) && ((8025 <= code) && (code <= 8031)))))))))))))) : (((8130 <= code) && (code <= 8132)) || (((8134 <= code) && (code <= 8140)) || (((8144 <= code) && (code <= 8147)) || (((8150 <= code) && (code <= 8155)) || (((8160 <= code) && (code <= 8172)) || (((8178 <= code) && (code <= 8180)) || (((8182 <= code) && (code <= 8188)) || (((8304 <= code) && (code <= 8305)) || (((8308 <= code) && (code <= 8313)) || (((8319 <= code) && (code <= 8329)) || (((8336 <= code) && (code <= 8348)) || (code === 8450))))))))))))))) : ((code < 12783) ? ((code < 11647) ? ((code < 9449) ? ((code === 8455) || (((8458 <= code) && (code <= 8467)) || ((code === 8469) || (((8473 <= code) && (code <= 8477)) || (((8490 <= code) && (code <= 8493)) || (((8495 <= code) && (code <= 8505)) || (((8508 <= code) && (code <= 8511)) || (((8517 <= code) && (code <= 8521)) || ((code === 8526) || (((8528 <= code) && (code <= 8585)) || (((9312 <= code) && (code <= 9371)) || ((!A2($elm$core$Basics$modBy, 2, code)) && ((8484 <= code) && (code <= 8488)))))))))))))) : (((9450 <= code) && (code <= 9471)) || (((10102 <= code) && (code <= 10131)) || (((11264 <= code) && (code <= 11492)) || (((11499 <= code) && (code <= 11502)) || (((11506 <= code) && (code <= 11507)) || ((code === 11517) || (((11520 <= code) && (code <= 11557)) || ((code === 11559) || ((code === 11565) || (((11568 <= code) && (code <= 11623)) || (code === 11631)))))))))))) : ((code < 12320) ? (((11648 <= code) && (code <= 11670)) || (((11680 <= code) && (code <= 11686)) || (((11688 <= code) && (code <= 11694)) || (((11696 <= code) && (code <= 11702)) || (((11704 <= code) && (code <= 11710)) || (((11712 <= code) && (code <= 11718)) || (((11720 <= code) && (code <= 11726)) || (((11728 <= code) && (code <= 11734)) || (((11736 <= code) && (code <= 11742)) || ((code === 11823) || ((12293 <= code) && (code <= 12295)))))))))))) : (((12321 <= code) && (code <= 12329)) || (((12337 <= code) && (code <= 12341)) || (((12344 <= code) && (code <= 12348)) || (((12353 <= code) && (code <= 12438)) || (((12445 <= code) && (code <= 12447)) || (((12449 <= code) && (code <= 12538)) || (((12540 <= code) && (code <= 12543)) || (((12549 <= code) && (code <= 12591)) || (((12593 <= code) && (code <= 12686)) || (((12690 <= code) && (code <= 12693)) || ((12704 <= code) && (code <= 12735)))))))))))))) : ((code < 43019) ? ((code < 42559) ? (((12784 <= code) && (code <= 12799)) || (((12832 <= code) && (code <= 12841)) || (((12872 <= code) && (code <= 12879)) || (((12881 <= code) && (code <= 12895)) || (((12928 <= code) && (code <= 12937)) || (((12977 <= code) && (code <= 12991)) || (((13312 <= code) && (code <= 19903)) || (((19968 <= code) && (code <= 42124)) || (((42192 <= code) && (code <= 42237)) || (((42240 <= code) && (code <= 42508)) || ((42512 <= code) && (code <= 42539)))))))))))) : (((42560 <= code) && (code <= 42606)) || (((42623 <= code) && (code <= 42653)) || (((42656 <= code) && (code <= 42735)) || (((42775 <= code) && (code <= 42783)) || (((42786 <= code) && (code <= 42888)) || (((42891 <= code) && (code <= 42954)) || (((42960 <= code) && (code <= 42961)) || (((42966 <= code) && (code <= 42969)) || (((42994 <= code) && (code <= 43009)) || (((43011 <= code) && (code <= 43013)) || (((43015 <= code) && (code <= 43018)) || ((A2($elm$core$Basics$modBy, 2, code) === 1) && ((42963 <= code) && (code <= 42965))))))))))))))) : ((code < 43395) ? (((43020 <= code) && (code <= 43042)) || (((43056 <= code) && (code <= 43061)) || (((43072 <= code) && (code <= 43123)) || (((43138 <= code) && (code <= 43187)) || (((43216 <= code) && (code <= 43225)) || (((43250 <= code) && (code <= 43255)) || ((code === 43259) || (((43261 <= code) && (code <= 43262)) || (((43264 <= code) && (code <= 43301)) || (((43312 <= code) && (code <= 43334)) || ((43360 <= code) && (code <= 43388)))))))))))) : (((43396 <= code) && (code <= 43442)) || (((43471 <= code) && (code <= 43481)) || (((43488 <= code) && (code <= 43492)) || (((43494 <= code) && (code <= 43518)) || (((43520 <= code) && (code <= 43560)) || (((43584 <= code) && (code <= 43586)) || (((43588 <= code) && (code <= 43595)) || (((43600 <= code) && (code <= 43609)) || (((43616 <= code) && (code <= 43638)) || ((code === 43642) || (((43646 <= code) && (code <= 43695)) || (code === 43697))))))))))))))))) : ((code < 71351) ? ((code < 67671) ? ((code < 65548) ? ((code < 64286) ? ((code < 43867) ? (((43701 <= code) && (code <= 43702)) || (((43705 <= code) && (code <= 43709)) || (((43739 <= code) && (code <= 43741)) || (((43744 <= code) && (code <= 43754)) || (((43762 <= code) && (code <= 43764)) || (((43777 <= code) && (code <= 43782)) || (((43785 <= code) && (code <= 43790)) || (((43793 <= code) && (code <= 43798)) || (((43808 <= code) && (code <= 43814)) || (((43816 <= code) && (code <= 43822)) || (((43824 <= code) && (code <= 43866)) || ((!A2($elm$core$Basics$modBy, 2, code)) && ((43712 <= code) && (code <= 43714)))))))))))))) : (((43868 <= code) && (code <= 43881)) || (((43888 <= code) && (code <= 44002)) || (((44016 <= code) && (code <= 44025)) || (((44032 <= code) && (code <= 55203)) || (((55216 <= code) && (code <= 55238)) || (((55243 <= code) && (code <= 55291)) || (((63744 <= code) && (code <= 64109)) || (((64112 <= code) && (code <= 64217)) || (((64256 <= code) && (code <= 64262)) || (((64275 <= code) && (code <= 64279)) || (code === 64285)))))))))))) : ((code < 65135) ? (((64287 <= code) && (code <= 64296)) || (((64298 <= code) && (code <= 64310)) || (((64312 <= code) && (code <= 64316)) || ((code === 64318) || (((64320 <= code) && (code <= 64321)) || (((64323 <= code) && (code <= 64324)) || (((64326 <= code) && (code <= 64433)) || (((64467 <= code) && (code <= 64829)) || (((64848 <= code) && (code <= 64911)) || (((64914 <= code) && (code <= 64967)) || ((65008 <= code) && (code <= 65019)))))))))))) : (((65136 <= code) && (code <= 65140)) || (((65142 <= code) && (code <= 65276)) || (((65296 <= code) && (code <= 65305)) || (((65313 <= code) && (code <= 65338)) || (((65345 <= code) && (code <= 65370)) || (((65382 <= code) && (code <= 65470)) || (((65474 <= code) && (code <= 65479)) || (((65482 <= code) && (code <= 65487)) || (((65490 <= code) && (code <= 65495)) || (((65498 <= code) && (code <= 65500)) || ((65536 <= code) && (code <= 65547)))))))))))))) : ((code < 66775) ? ((code < 66272) ? (((65549 <= code) && (code <= 65574)) || (((65576 <= code) && (code <= 65594)) || (((65596 <= code) && (code <= 65597)) || (((65599 <= code) && (code <= 65613)) || (((65616 <= code) && (code <= 65629)) || (((65664 <= code) && (code <= 65786)) || (((65799 <= code) && (code <= 65843)) || (((65856 <= code) && (code <= 65912)) || (((65930 <= code) && (code <= 65931)) || (((66176 <= code) && (code <= 66204)) || ((66208 <= code) && (code <= 66256)))))))))))) : (((66273 <= code) && (code <= 66299)) || (((66304 <= code) && (code <= 66339)) || (((66349 <= code) && (code <= 66378)) || (((66384 <= code) && (code <= 66421)) || (((66432 <= code) && (code <= 66461)) || (((66464 <= code) && (code <= 66499)) || (((66504 <= code) && (code <= 66511)) || (((66513 <= code) && (code <= 66517)) || (((66560 <= code) && (code <= 66717)) || (((66720 <= code) && (code <= 66729)) || ((66736 <= code) && (code <= 66771))))))))))))) : ((code < 67071) ? (((66776 <= code) && (code <= 66811)) || (((66816 <= code) && (code <= 66855)) || (((66864 <= code) && (code <= 66915)) || (((66928 <= code) && (code <= 66938)) || (((66940 <= code) && (code <= 66954)) || (((66956 <= code) && (code <= 66962)) || (((66964 <= code) && (code <= 66965)) || (((66967 <= code) && (code <= 66977)) || (((66979 <= code) && (code <= 66993)) || (((66995 <= code) && (code <= 67001)) || ((67003 <= code) && (code <= 67004)))))))))))) : (((67072 <= code) && (code <= 67382)) || (((67392 <= code) && (code <= 67413)) || (((67424 <= code) && (code <= 67431)) || (((67456 <= code) && (code <= 67461)) || (((67463 <= code) && (code <= 67504)) || (((67506 <= code) && (code <= 67514)) || (((67584 <= code) && (code <= 67589)) || ((code === 67592) || (((67594 <= code) && (code <= 67637)) || (((67639 <= code) && (code <= 67640)) || ((code === 67644) || ((67647 <= code) && (code <= 67669)))))))))))))))) : ((code < 69871) ? ((code < 68471) ? ((code < 68116) ? (((67672 <= code) && (code <= 67702)) || (((67705 <= code) && (code <= 67742)) || (((67751 <= code) && (code <= 67759)) || (((67808 <= code) && (code <= 67826)) || (((67828 <= code) && (code <= 67829)) || (((67835 <= code) && (code <= 67867)) || (((67872 <= code) && (code <= 67897)) || (((67968 <= code) && (code <= 68023)) || (((68028 <= code) && (code <= 68047)) || (((68050 <= code) && (code <= 68096)) || ((68112 <= code) && (code <= 68115)))))))))))) : (((68117 <= code) && (code <= 68119)) || (((68121 <= code) && (code <= 68149)) || (((68160 <= code) && (code <= 68168)) || (((68192 <= code) && (code <= 68222)) || (((68224 <= code) && (code <= 68255)) || (((68288 <= code) && (code <= 68295)) || (((68297 <= code) && (code <= 68324)) || (((68331 <= code) && (code <= 68335)) || (((68352 <= code) && (code <= 68405)) || (((68416 <= code) && (code <= 68437)) || ((68440 <= code) && (code <= 68466))))))))))))) : ((code < 69423) ? (((68472 <= code) && (code <= 68497)) || (((68521 <= code) && (code <= 68527)) || (((68608 <= code) && (code <= 68680)) || (((68736 <= code) && (code <= 68786)) || (((68800 <= code) && (code <= 68850)) || (((68858 <= code) && (code <= 68899)) || (((68912 <= code) && (code <= 68921)) || (((69216 <= code) && (code <= 69246)) || (((69248 <= code) && (code <= 69289)) || (((69296 <= code) && (code <= 69297)) || ((69376 <= code) && (code <= 69415)))))))))))) : (((69424 <= code) && (code <= 69445)) || (((69457 <= code) && (code <= 69460)) || (((69488 <= code) && (code <= 69505)) || (((69552 <= code) && (code <= 69579)) || (((69600 <= code) && (code <= 69622)) || (((69635 <= code) && (code <= 69687)) || (((69714 <= code) && (code <= 69743)) || (((69745 <= code) && (code <= 69746)) || ((code === 69749) || (((69763 <= code) && (code <= 69807)) || ((69840 <= code) && (code <= 69864)))))))))))))) : ((code < 70404) ? ((code < 70112) ? (((69872 <= code) && (code <= 69881)) || (((69891 <= code) && (code <= 69926)) || (((69942 <= code) && (code <= 69951)) || ((code === 69956) || ((code === 69959) || (((69968 <= code) && (code <= 70002)) || ((code === 70006) || (((70019 <= code) && (code <= 70066)) || (((70081 <= code) && (code <= 70084)) || (((70096 <= code) && (code <= 70106)) || (code === 70108))))))))))) : (((70113 <= code) && (code <= 70132)) || (((70144 <= code) && (code <= 70161)) || (((70163 <= code) && (code <= 70187)) || (((70207 <= code) && (code <= 70208)) || (((70272 <= code) && (code <= 70278)) || ((code === 70280) || (((70282 <= code) && (code <= 70285)) || (((70287 <= code) && (code <= 70301)) || (((70303 <= code) && (code <= 70312)) || (((70320 <= code) && (code <= 70366)) || ((70384 <= code) && (code <= 70393))))))))))))) : ((code < 70735) ? (((70405 <= code) && (code <= 70412)) || (((70415 <= code) && (code <= 70416)) || (((70419 <= code) && (code <= 70440)) || (((70442 <= code) && (code <= 70448)) || (((70450 <= code) && (code <= 70451)) || (((70453 <= code) && (code <= 70457)) || ((code === 70461) || ((code === 70480) || (((70493 <= code) && (code <= 70497)) || (((70656 <= code) && (code <= 70708)) || ((70727 <= code) && (code <= 70730)))))))))))) : (((70736 <= code) && (code <= 70745)) || (((70751 <= code) && (code <= 70753)) || (((70784 <= code) && (code <= 70831)) || (((70852 <= code) && (code <= 70853)) || ((code === 70855) || (((70864 <= code) && (code <= 70873)) || (((71040 <= code) && (code <= 71086)) || (((71128 <= code) && (code <= 71131)) || (((71168 <= code) && (code <= 71215)) || ((code === 71236) || (((71248 <= code) && (code <= 71257)) || ((71296 <= code) && (code <= 71338))))))))))))))))) : ((code < 119893) ? ((code < 73727) ? ((code < 72703) ? ((code < 71959) ? ((code === 71352) || (((71360 <= code) && (code <= 71369)) || (((71424 <= code) && (code <= 71450)) || (((71472 <= code) && (code <= 71483)) || (((71488 <= code) && (code <= 71494)) || (((71680 <= code) && (code <= 71723)) || (((71840 <= code) && (code <= 71922)) || (((71935 <= code) && (code <= 71942)) || ((code === 71945) || (((71948 <= code) && (code <= 71955)) || ((71957 <= code) && (code <= 71958)))))))))))) : (((71960 <= code) && (code <= 71983)) || (((72016 <= code) && (code <= 72025)) || (((72096 <= code) && (code <= 72103)) || (((72106 <= code) && (code <= 72144)) || ((code === 72192) || (((72203 <= code) && (code <= 72242)) || ((code === 72250) || ((code === 72272) || (((72284 <= code) && (code <= 72329)) || ((code === 72349) || (((72368 <= code) && (code <= 72440)) || ((A2($elm$core$Basics$modBy, 2, code) === 1) && (((71999 <= code) && (code <= 72001)) || ((72161 <= code) && (code <= 72163)))))))))))))))) : ((code < 73062) ? (((72704 <= code) && (code <= 72712)) || (((72714 <= code) && (code <= 72750)) || ((code === 72768) || (((72784 <= code) && (code <= 72812)) || (((72818 <= code) && (code <= 72847)) || (((72960 <= code) && (code <= 72966)) || (((72968 <= code) && (code <= 72969)) || (((72971 <= code) && (code <= 73008)) || ((code === 73030) || (((73040 <= code) && (code <= 73049)) || ((73056 <= code) && (code <= 73061)))))))))))) : (((73063 <= code) && (code <= 73064)) || (((73066 <= code) && (code <= 73097)) || ((code === 73112) || (((73120 <= code) && (code <= 73129)) || (((73440 <= code) && (code <= 73458)) || ((code === 73474) || (((73476 <= code) && (code <= 73488)) || (((73490 <= code) && (code <= 73523)) || (((73552 <= code) && (code <= 73561)) || ((code === 73648) || ((73664 <= code) && (code <= 73684)))))))))))))) : ((code < 94098) ? ((code < 92863) ? (((73728 <= code) && (code <= 74649)) || (((74752 <= code) && (code <= 74862)) || (((74880 <= code) && (code <= 75075)) || (((77712 <= code) && (code <= 77808)) || (((77824 <= code) && (code <= 78895)) || (((78913 <= code) && (code <= 78918)) || (((82944 <= code) && (code <= 83526)) || (((92160 <= code) && (code <= 92728)) || (((92736 <= code) && (code <= 92766)) || (((92768 <= code) && (code <= 92777)) || ((92784 <= code) && (code <= 92862)))))))))))) : (((92864 <= code) && (code <= 92873)) || (((92880 <= code) && (code <= 92909)) || (((92928 <= code) && (code <= 92975)) || (((92992 <= code) && (code <= 92995)) || (((93008 <= code) && (code <= 93017)) || (((93019 <= code) && (code <= 93025)) || (((93027 <= code) && (code <= 93047)) || (((93053 <= code) && (code <= 93071)) || (((93760 <= code) && (code <= 93846)) || (((93952 <= code) && (code <= 94026)) || (code === 94032)))))))))))) : ((code < 110927) ? (((94099 <= code) && (code <= 94111)) || (((94176 <= code) && (code <= 94177)) || ((code === 94179) || (((94208 <= code) && (code <= 100343)) || (((100352 <= code) && (code <= 101589)) || (((101632 <= code) && (code <= 101640)) || (((110576 <= code) && (code <= 110579)) || (((110581 <= code) && (code <= 110587)) || (((110589 <= code) && (code <= 110590)) || (((110592 <= code) && (code <= 110882)) || (code === 110898))))))))))) : (((110928 <= code) && (code <= 110930)) || ((code === 110933) || (((110948 <= code) && (code <= 110951)) || (((110960 <= code) && (code <= 111355)) || (((113664 <= code) && (code <= 113770)) || (((113776 <= code) && (code <= 113788)) || (((113792 <= code) && (code <= 113800)) || (((113808 <= code) && (code <= 113817)) || (((119488 <= code) && (code <= 119507)) || (((119520 <= code) && (code <= 119539)) || (((119648 <= code) && (code <= 119672)) || ((119808 <= code) && (code <= 119892)))))))))))))))) : ((code < 124911) ? ((code < 120597) ? ((code < 120085) ? (((119894 <= code) && (code <= 119964)) || (((119966 <= code) && (code <= 119967)) || ((code === 119970) || (((119973 <= code) && (code <= 119974)) || (((119977 <= code) && (code <= 119980)) || (((119982 <= code) && (code <= 119993)) || ((code === 119995) || (((119997 <= code) && (code <= 120003)) || (((120005 <= code) && (code <= 120069)) || (((120071 <= code) && (code <= 120074)) || ((120077 <= code) && (code <= 120084)))))))))))) : (((120086 <= code) && (code <= 120092)) || (((120094 <= code) && (code <= 120121)) || (((120123 <= code) && (code <= 120126)) || (((120128 <= code) && (code <= 120132)) || ((code === 120134) || (((120138 <= code) && (code <= 120144)) || (((120146 <= code) && (code <= 120485)) || (((120488 <= code) && (code <= 120512)) || (((120514 <= code) && (code <= 120538)) || (((120540 <= code) && (code <= 120570)) || ((120572 <= code) && (code <= 120596))))))))))))) : ((code < 123135) ? (((120598 <= code) && (code <= 120628)) || (((120630 <= code) && (code <= 120654)) || (((120656 <= code) && (code <= 120686)) || (((120688 <= code) && (code <= 120712)) || (((120714 <= code) && (code <= 120744)) || (((120746 <= code) && (code <= 120770)) || (((120772 <= code) && (code <= 120779)) || (((120782 <= code) && (code <= 120831)) || (((122624 <= code) && (code <= 122654)) || (((122661 <= code) && (code <= 122666)) || ((122928 <= code) && (code <= 122989)))))))))))) : (((123136 <= code) && (code <= 123180)) || (((123191 <= code) && (code <= 123197)) || (((123200 <= code) && (code <= 123209)) || ((code === 123214) || (((123536 <= code) && (code <= 123565)) || (((123584 <= code) && (code <= 123627)) || (((123632 <= code) && (code <= 123641)) || (((124112 <= code) && (code <= 124139)) || (((124144 <= code) && (code <= 124153)) || (((124896 <= code) && (code <= 124902)) || (((124904 <= code) && (code <= 124907)) || ((124909 <= code) && (code <= 124910))))))))))))))) : ((code < 126560) ? ((code < 126463) ? (((124912 <= code) && (code <= 124926)) || (((124928 <= code) && (code <= 125124)) || (((125127 <= code) && (code <= 125135)) || (((125184 <= code) && (code <= 125251)) || ((code === 125259) || (((125264 <= code) && (code <= 125273)) || (((126065 <= code) && (code <= 126123)) || (((126125 <= code) && (code <= 126127)) || (((126129 <= code) && (code <= 126132)) || (((126209 <= code) && (code <= 126253)) || ((126255 <= code) && (code <= 126269)))))))))))) : (((126464 <= code) && (code <= 126467)) || (((126469 <= code) && (code <= 126495)) || (((126497 <= code) && (code <= 126498)) || ((code === 126500) || ((code === 126503) || (((126505 <= code) && (code <= 126514)) || (((126516 <= code) && (code <= 126519)) || ((code === 126530) || (((126541 <= code) && (code <= 126543)) || (((126545 <= code) && (code <= 126546)) || ((code === 126548) || ((A2($elm$core$Basics$modBy, 2, code) === 1) && (((126521 <= code) && (code <= 126523)) || (((126535 <= code) && (code <= 126539)) || ((126551 <= code) && (code <= 126559))))))))))))))))) : ((code < 126634) ? (((126561 <= code) && (code <= 126562)) || ((code === 126564) || (((126567 <= code) && (code <= 126570)) || (((126572 <= code) && (code <= 126578)) || (((126580 <= code) && (code <= 126583)) || (((126585 <= code) && (code <= 126588)) || ((code === 126590) || (((126592 <= code) && (code <= 126601)) || (((126603 <= code) && (code <= 126619)) || (((126625 <= code) && (code <= 126627)) || ((126629 <= code) && (code <= 126633)))))))))))) : (((126635 <= code) && (code <= 126651)) || (((127232 <= code) && (code <= 127244)) || (((130032 <= code) && (code <= 130041)) || (((131072 <= code) && (code <= 173791)) || (((173824 <= code) && (code <= 177977)) || (((177984 <= code) && (code <= 178205)) || (((178208 <= code) && (code <= 183969)) || (((183984 <= code) && (code <= 191456)) || (((191472 <= code) && (code <= 192093)) || (((194560 <= code) && (code <= 195101)) || (((196608 <= code) && (code <= 201546)) || ((201552 <= code) && (code <= 205743))))))))))))))))))))))));
};
var $elm$core$String$toLower = _String_toLower;
var $elm$core$String$toUpper = _String_toUpper;
var $stil4m$elm_syntax$Char$Extra$unicodeIsLowerFast = function (c) {
	var code = $elm$core$Char$toCode(c);
	var cString = $elm$core$String$fromChar(c);
	return $stil4m$elm_syntax$Char$Extra$charCodeIsLower(code) || ((_Utils_eq(
		$elm$core$String$toLower(cString),
		cString + '') && (!_Utils_eq(
		$elm$core$String$toUpper(cString),
		cString + ''))) ? ((code <= 836) || (((838 <= code) && (code <= 8559)) || (((8576 <= code) && (code <= 9423)) || ((9450 <= code) && (code <= 983040))))) : ((code < 43001) ? ((code < 8457) ? ((code < 590) ? (((311 <= code) && (code <= 312)) || (((396 <= code) && (code <= 397)) || (((409 <= code) && (code <= 411)) || (((426 <= code) && (code <= 427)) || (((441 <= code) && (code <= 442)) || (((445 <= code) && (code <= 447)) || ((code === 545) || ((563 <= code) && (code <= 569))))))))) : (((591 <= code) && (code <= 659)) || (((661 <= code) && (code <= 687)) || (((1019 <= code) && (code <= 1020)) || (((1376 <= code) && (code <= 1416)) || (((7424 <= code) && (code <= 7467)) || (((7531 <= code) && (code <= 7543)) || (((7545 <= code) && (code <= 7578)) || (((7829 <= code) && (code <= 7837)) || (code === 7839)))))))))) : ((code < 11376) ? ((code === 8458) || (((8462 <= code) && (code <= 8463)) || ((code === 8467) || ((code === 8495) || ((code === 8500) || ((code === 8505) || (((8508 <= code) && (code <= 8509)) || ((8518 <= code) && (code <= 8521))))))))) : ((code === 11377) || (((11379 <= code) && (code <= 11380)) || (((11382 <= code) && (code <= 11387)) || (((11491 <= code) && (code <= 11492)) || (((42799 <= code) && (code <= 42801)) || (((42865 <= code) && (code <= 42872)) || ((code === 42894) || (((42899 <= code) && (code <= 42901)) || ((code === 42927) || ((A2($elm$core$Basics$modBy, 2, code) === 1) && ((42963 <= code) && (code <= 42965)))))))))))))) : ((code < 120353) ? ((code < 119994) ? ((code === 43002) || (((43824 <= code) && (code <= 43866)) || (((43872 <= code) && (code <= 43880)) || (((119834 <= code) && (code <= 119859)) || (((119886 <= code) && (code <= 119892)) || (((119894 <= code) && (code <= 119911)) || (((119938 <= code) && (code <= 119963)) || ((119990 <= code) && (code <= 119993))))))))) : ((code === 119995) || (((119997 <= code) && (code <= 120003)) || (((120005 <= code) && (code <= 120015)) || (((120042 <= code) && (code <= 120067)) || (((120094 <= code) && (code <= 120119)) || (((120146 <= code) && (code <= 120171)) || (((120198 <= code) && (code <= 120223)) || (((120250 <= code) && (code <= 120275)) || ((120302 <= code) && (code <= 120327))))))))))) : ((code < 120655) ? (((120354 <= code) && (code <= 120379)) || (((120406 <= code) && (code <= 120431)) || (((120458 <= code) && (code <= 120485)) || (((120514 <= code) && (code <= 120538)) || (((120540 <= code) && (code <= 120545)) || (((120572 <= code) && (code <= 120596)) || (((120598 <= code) && (code <= 120603)) || ((120630 <= code) && (code <= 120654))))))))) : (((120656 <= code) && (code <= 120661)) || (((120688 <= code) && (code <= 120712)) || (((120714 <= code) && (code <= 120719)) || (((120746 <= code) && (code <= 120770)) || (((120772 <= code) && (code <= 120777)) || ((code === 120779) || (((122624 <= code) && (code <= 122633)) || (((122635 <= code) && (code <= 122654)) || ((122661 <= code) && (code <= 122666))))))))))))));
};
var $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode = A4($stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateMapWithRangeWithoutLinebreak, $stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Char$Extra$unicodeIsLowerFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast, $stil4m$elm_syntax$Elm$Parser$Tokens$isNotReserved);
var $elm$core$Basics$ge = _Utils_ge;
var $stil4m$elm_syntax$ParserFast$atLeastOneWhile = function (isGood) {
	return function (s0) {
		var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileHelp, isGood, s0.c, s0.t, s0.S, s0.b, s0.g);
		return (!(s0.c - s1.c)) ? A2(
			$stil4m$elm_syntax$ParserFast$Bad,
			false,
			A2($stil4m$elm_syntax$ParserFast$ExpectingAnyChar, s0.t, s0.S)) : A2(
			$stil4m$elm_syntax$ParserFast$Good,
			A3($elm$core$String$slice, s0.c, s1.c, s0.b),
			s1);
	};
};
var $stil4m$elm_syntax$ParserFast$loopUntilHelp = F7(
	function (committedSoFar, endParser, element, soFar, reduce, foldedToRes, s0) {
		loopUntilHelp:
		while (true) {
			var parseEnd = endParser;
			var parseElement = element;
			var _v0 = parseEnd(s0);
			if (!_v0.$) {
				var s1 = _v0.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					foldedToRes(soFar),
					s1);
			} else {
				var endCommitted = _v0.a;
				var endX = _v0.b;
				if (endCommitted) {
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, endX);
				} else {
					var _v1 = parseElement(s0);
					if (!_v1.$) {
						var elementResult = _v1.a;
						var s1 = _v1.b;
						var $temp$committedSoFar = true,
							$temp$endParser = endParser,
							$temp$element = element,
							$temp$soFar = A2(reduce, elementResult, soFar),
							$temp$reduce = reduce,
							$temp$foldedToRes = foldedToRes,
							$temp$s0 = s1;
						committedSoFar = $temp$committedSoFar;
						endParser = $temp$endParser;
						element = $temp$element;
						soFar = $temp$soFar;
						reduce = $temp$reduce;
						foldedToRes = $temp$foldedToRes;
						s0 = $temp$s0;
						continue loopUntilHelp;
					} else {
						var elementCommitted = _v1.a;
						var x = _v1.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, committedSoFar || elementCommitted, x);
					}
				}
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$loopUntil = F5(
	function (endParser, element, initialFolded, reduce, foldedToRes) {
		return function (s) {
			return A7($stil4m$elm_syntax$ParserFast$loopUntilHelp, false, endParser, element, initialFolded, reduce, foldedToRes, s);
		};
	});
var $stil4m$elm_syntax$ParserFast$mapWithRange = F2(
	function (combineStartAndResult, _v0) {
		var parse = _v0;
		return function (s0) {
			var _v1 = parse(s0);
			if (!_v1.$) {
				var a = _v1.a;
				var s1 = _v1.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A2(
						combineStartAndResult,
						{
							w: {p: s1.S, t: s1.t},
							z: {p: s0.S, t: s0.t}
						},
						a),
					s1);
			} else {
				var committed = _v1.a;
				var x = _v1.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$glslExpressionAfterOpeningSquareBracket = A2(
	$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
	'glsl|',
	A2(
		$stil4m$elm_syntax$ParserFast$mapWithRange,
		F2(
			function (range, s) {
				return {
					ao: $stil4m$elm_syntax$Rope$empty,
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						{
							w: {p: range.w.p + 2, t: range.w.t},
							z: {p: range.z.p - 6, t: range.z.t}
						},
						$stil4m$elm_syntax$Elm$Syntax$Expression$GLSLExpression(s))
				};
			}),
		A5(
			$stil4m$elm_syntax$ParserFast$loopUntil,
			A2($stil4m$elm_syntax$ParserFast$symbol, '|]', 0),
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				A2($stil4m$elm_syntax$ParserFast$symbol, '|', '|'),
				$stil4m$elm_syntax$ParserFast$atLeastOneWhile(
					function (c) {
						return c !== '|';
					})),
			'',
			F2(
				function (extension, soFar) {
					return soFar + (extension + '');
				}),
			$elm$core$Basics$identity)));
var $stil4m$elm_syntax$ParserFast$ExpectingKeyword = F3(
	function (a, b, c) {
		return {$: 3, a: a, b: b, c: c};
	});
var $stil4m$elm_syntax$Char$Extra$isLatinAlphaNumOrUnderscoreFast = function (c) {
	var code = $elm$core$Char$toCode(c);
	return $stil4m$elm_syntax$Char$Extra$charCodeIsLower(code) || ($stil4m$elm_syntax$Char$Extra$charCodeIsUpper(code) || ($stil4m$elm_syntax$Char$Extra$charCodeIsDigit(code) || (code === 95)));
};
var $stil4m$elm_syntax$ParserFast$isSubCharAlphaNumOrUnderscore = F2(
	function (offset, string) {
		return A2(
			$elm$core$String$any,
			$stil4m$elm_syntax$Char$Extra$isLatinAlphaNumOrUnderscoreFast,
			A3($elm$core$String$slice, offset, offset + 1, string));
	});
var $stil4m$elm_syntax$ParserFast$keyword = F2(
	function (kwd, res) {
		var kwdLength = $elm$core$String$length(kwd);
		return function (s) {
			var newOffset = s.c + kwdLength;
			return (_Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				kwd + '') && (!A2($stil4m$elm_syntax$ParserFast$isSubCharAlphaNumOrUnderscore, newOffset, s.b))) ? A2(
				$stil4m$elm_syntax$ParserFast$Good,
				res,
				{S: s.S + kwdLength, g: s.g, c: newOffset, t: s.t, b: s.b}) : A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A3($stil4m$elm_syntax$ParserFast$ExpectingKeyword, s.t, s.S, kwd));
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$inToken = A2($stil4m$elm_syntax$ParserFast$keyword, 'in', 0);
var $stil4m$elm_syntax$ParserFast$keywordFollowedBy = F2(
	function (kwd, _v0) {
		var parseNext = _v0;
		var kwdLength = $elm$core$String$length(kwd);
		return function (s) {
			var newOffset = s.c + kwdLength;
			return (_Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				kwd + '') && (!A2($stil4m$elm_syntax$ParserFast$isSubCharAlphaNumOrUnderscore, newOffset, s.b))) ? $stil4m$elm_syntax$ParserFast$pStepCommit(
				parseNext(
					{S: s.S + kwdLength, g: s.g, c: newOffset, t: s.t, b: s.b})) : A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A3($stil4m$elm_syntax$ParserFast$ExpectingKeyword, s.t, s.S, kwd));
		};
	});
var $stil4m$elm_syntax$ParserFast$map2 = F3(
	function (func, _v0, _v1) {
		var parseA = _v0;
		var parseB = _v1;
		return function (s0) {
			var _v2 = parseA(s0);
			if (_v2.$ === 1) {
				var committed = _v2.a;
				var x = _v2.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v2.a;
				var s1 = _v2.b;
				var _v3 = parseB(s1);
				if (_v3.$ === 1) {
					var x = _v3.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v3.a;
					var s2 = _v3.b;
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						A2(func, a, b),
						s2);
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$columnIndentAndThen = function (callback) {
	return function (s) {
		var _v0 = A2(callback, s.S, s.g);
		var parse = _v0;
		return parse(s);
	};
};
var $stil4m$elm_syntax$ParserFast$ExpectingCustom = F3(
	function (a, b, c) {
		return {$: 6, a: a, b: b, c: c};
	});
var $stil4m$elm_syntax$ParserFast$problem = function (msg) {
	return function (s) {
		return A2(
			$stil4m$elm_syntax$ParserFast$Bad,
			false,
			A3($stil4m$elm_syntax$ParserFast$ExpectingCustom, s.t, s.S, msg));
	};
};
var $stil4m$elm_syntax$Elm$Parser$Layout$problemTopIndentation = $stil4m$elm_syntax$ParserFast$problem('must be on top indentation');
var $stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy = function (nextParser) {
	return $stil4m$elm_syntax$ParserFast$columnIndentAndThen(
		F2(
			function (column, indent) {
				return (!(column - indent)) ? nextParser : $stil4m$elm_syntax$Elm$Parser$Layout$problemTopIndentation;
			}));
};
var $stil4m$elm_syntax$ParserFast$skipWhileWhitespaceHelp = F5(
	function (offset, row, col, src, indent) {
		skipWhileWhitespaceHelp:
		while (true) {
			var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
			switch (_v0) {
				case ' ':
					var $temp$offset = offset + 1,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileWhitespaceHelp;
				case '\n':
					var $temp$offset = offset + 1,
						$temp$row = row + 1,
						$temp$col = 1,
						$temp$src = src,
						$temp$indent = indent;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileWhitespaceHelp;
				case '\u000D':
					var $temp$offset = offset + 1,
						$temp$row = row,
						$temp$col = col + 1,
						$temp$src = src,
						$temp$indent = indent;
					offset = $temp$offset;
					row = $temp$row;
					col = $temp$col;
					src = $temp$src;
					indent = $temp$indent;
					continue skipWhileWhitespaceHelp;
				default:
					return {S: col, g: indent, c: offset, t: row, b: src};
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$followedBySkipWhileWhitespace = function (_v0) {
	var parseBefore = _v0;
	return function (s0) {
		var _v1 = parseBefore(s0);
		if (!_v1.$) {
			var res = _v1.a;
			var s1 = _v1.b;
			var s2 = A5($stil4m$elm_syntax$ParserFast$skipWhileWhitespaceHelp, s1.c, s1.t, s1.S, s1.b, s1.g);
			return A2($stil4m$elm_syntax$ParserFast$Good, res, s2);
		} else {
			var bad = _v1;
			return bad;
		}
	};
};
var $stil4m$elm_syntax$ParserFast$map2OrSucceed = F4(
	function (func, _v0, _v1, fallback) {
		var parseA = _v0;
		var parseB = _v1;
		return function (s0) {
			var _v2 = parseA(s0);
			if (_v2.$ === 1) {
				var c1 = _v2.a;
				var x = _v2.b;
				return c1 ? A2($stil4m$elm_syntax$ParserFast$Bad, true, x) : A2($stil4m$elm_syntax$ParserFast$Good, fallback, s0);
			} else {
				var a = _v2.a;
				var s1 = _v2.b;
				var _v3 = parseB(s1);
				if (_v3.$ === 1) {
					var x = _v3.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v3.a;
					var s2 = _v3.b;
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						A2(func, a, b),
						s2);
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$offsetSourceAndThen = function (callback) {
	return function (s) {
		var _v0 = A2(callback, s.c, s.b);
		var parse = _v0;
		return parse(s);
	};
};
var $stil4m$elm_syntax$Elm$Parser$Comments$problemUnexpectedDocumentation = $stil4m$elm_syntax$ParserFast$problem('unexpected documentation comment');
var $stil4m$elm_syntax$Elm$Parser$Comments$multilineComment = $stil4m$elm_syntax$ParserFast$offsetSourceAndThen(
	F2(
		function (offset, source) {
			var _v0 = A3($elm$core$String$slice, offset + 2, offset + 3, source);
			if (_v0 === '|') {
				return $stil4m$elm_syntax$Elm$Parser$Comments$problemUnexpectedDocumentation;
			} else {
				return $stil4m$elm_syntax$Elm$Parser$Comments$multiLineCommentNoCheck;
			}
		}));
var $stil4m$elm_syntax$Rope$Leaf = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $stil4m$elm_syntax$Rope$one = function (onlyElement) {
	return A2($stil4m$elm_syntax$Rope$Leaf, onlyElement, 0);
};
var $stil4m$elm_syntax$ParserFast$loopWhileSucceedsHelp = F5(
	function (element, soFar, reduce, foldedToRes, s0) {
		loopWhileSucceedsHelp:
		while (true) {
			var parseElement = element;
			var _v0 = parseElement(s0);
			if (!_v0.$) {
				var elementResult = _v0.a;
				var s1 = _v0.b;
				var $temp$element = element,
					$temp$soFar = A2(reduce, elementResult, soFar),
					$temp$reduce = reduce,
					$temp$foldedToRes = foldedToRes,
					$temp$s0 = s1;
				element = $temp$element;
				soFar = $temp$soFar;
				reduce = $temp$reduce;
				foldedToRes = $temp$foldedToRes;
				s0 = $temp$s0;
				continue loopWhileSucceedsHelp;
			} else {
				var elementCommitted = _v0.a;
				var x = _v0.b;
				return elementCommitted ? A2($stil4m$elm_syntax$ParserFast$Bad, true, x) : A2(
					$stil4m$elm_syntax$ParserFast$Good,
					foldedToRes(soFar),
					s0);
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$loopWhileSucceeds = F4(
	function (element, initialFolded, reduce, foldedToRes) {
		return function (s) {
			return A5($stil4m$elm_syntax$ParserFast$loopWhileSucceedsHelp, element, initialFolded, reduce, foldedToRes, s);
		};
	});
var $stil4m$elm_syntax$Rope$prependToFilled = F2(
	function (rightLikelyFilled, left) {
		if (left.$ === 1) {
			return $elm$core$Maybe$Just(rightLikelyFilled);
		} else {
			var leftLikelyFilled = left.a;
			return $elm$core$Maybe$Just(
				A2($stil4m$elm_syntax$Rope$Branch2, leftLikelyFilled, rightLikelyFilled));
		}
	});
var $stil4m$elm_syntax$ParserFast$whileMapWithRange = F2(
	function (isGood, rangeAndConsumedStringToRes) {
		return function (s0) {
			var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileHelp, isGood, s0.c, s0.t, s0.S, s0.b, s0.g);
			return A2(
				$stil4m$elm_syntax$ParserFast$Good,
				A2(
					rangeAndConsumedStringToRes,
					{
						w: {p: s1.S, t: s1.t},
						z: {p: s0.S, t: s0.t}
					},
					A3($elm$core$String$slice, s0.c, s1.c, s0.b)),
				s1);
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Comments$singleLineComment = A2(
	$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
	'--',
	A2(
		$stil4m$elm_syntax$ParserFast$whileMapWithRange,
		function (c) {
			switch (c) {
				case '\u000D':
					return false;
				case '\n':
					return false;
				default:
					return !$stil4m$elm_syntax$Char$Extra$isUtf16Surrogate(c);
			}
		},
		F2(
			function (range, content) {
				return A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					{
						w: {p: range.w.p, t: range.z.t},
						z: {p: range.z.p - 2, t: range.z.t}
					},
					'--' + content);
			})));
var $stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmptyLoop = A4(
	$stil4m$elm_syntax$ParserFast$loopWhileSucceeds,
	$stil4m$elm_syntax$ParserFast$followedBySkipWhileWhitespace(
		A2($stil4m$elm_syntax$ParserFast$oneOf2, $stil4m$elm_syntax$Elm$Parser$Comments$singleLineComment, $stil4m$elm_syntax$Elm$Parser$Comments$multilineComment)),
	$stil4m$elm_syntax$Rope$empty,
	F2(
		function (right, soFar) {
			return A2(
				$stil4m$elm_syntax$Rope$prependToFilled,
				$stil4m$elm_syntax$Rope$one(right),
				soFar);
		}),
	$elm$core$Basics$identity);
var $stil4m$elm_syntax$Elm$Parser$Layout$fromMultilineCommentNodeOrEmptyOnProblem = A4(
	$stil4m$elm_syntax$ParserFast$map2OrSucceed,
	F2(
		function (comment, commentsAfter) {
			return A2(
				$stil4m$elm_syntax$Rope$filledPrependTo,
				commentsAfter,
				$stil4m$elm_syntax$Rope$one(comment));
		}),
	$stil4m$elm_syntax$ParserFast$followedBySkipWhileWhitespace($stil4m$elm_syntax$Elm$Parser$Comments$multilineComment),
	$stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmptyLoop,
	$stil4m$elm_syntax$Rope$empty);
var $stil4m$elm_syntax$Elm$Parser$Layout$fromSingleLineCommentNode = A3(
	$stil4m$elm_syntax$ParserFast$map2,
	F2(
		function (content, commentsAfter) {
			return A2(
				$stil4m$elm_syntax$Rope$filledPrependTo,
				commentsAfter,
				$stil4m$elm_syntax$Rope$one(content));
		}),
	$stil4m$elm_syntax$ParserFast$followedBySkipWhileWhitespace($stil4m$elm_syntax$Elm$Parser$Comments$singleLineComment),
	$stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmptyLoop);
var $stil4m$elm_syntax$ParserFast$offsetSourceAndThenOrSucceed = F2(
	function (callback, fallback) {
		return function (s) {
			var _v0 = A2(callback, s.c, s.b);
			if (_v0.$ === 1) {
				return A2($stil4m$elm_syntax$ParserFast$Good, fallback, s);
			} else {
				var parse = _v0.a;
				return parse(s);
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$skipWhileWhitespaceFollowedBy = function (_v0) {
	var parseNext = _v0;
	return function (s0) {
		var s1 = A5($stil4m$elm_syntax$ParserFast$skipWhileWhitespaceHelp, s0.c, s0.t, s0.S, s0.b, s0.g);
		return $stil4m$elm_syntax$ParserFast$pStepCommit(
			parseNext(s1));
	};
};
var $stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmpty = $stil4m$elm_syntax$ParserFast$skipWhileWhitespaceFollowedBy(
	A2(
		$stil4m$elm_syntax$ParserFast$offsetSourceAndThenOrSucceed,
		F2(
			function (offset, source) {
				var _v0 = A3($elm$core$String$slice, offset, offset + 2, source);
				switch (_v0) {
					case '--':
						return $elm$core$Maybe$Just($stil4m$elm_syntax$Elm$Parser$Layout$fromSingleLineCommentNode);
					case '{-':
						return $elm$core$Maybe$Just($stil4m$elm_syntax$Elm$Parser$Layout$fromMultilineCommentNodeOrEmptyOnProblem);
					default:
						return $elm$core$Maybe$Nothing;
				}
			}),
		$stil4m$elm_syntax$Rope$empty));
var $stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout = $stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmpty;
var $stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedBy = function (nextParser) {
	return A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (commentsBefore, after) {
				return {ao: commentsBefore, a: after};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(nextParser));
};
var $stil4m$elm_syntax$ParserFast$lazy = function (thunk) {
	return function (s) {
		var _v0 = thunk(0);
		var parse = _v0;
		return parse(s);
	};
};
var $stil4m$elm_syntax$ParserFast$atLeastOneWhileWithoutLinebreak = function (isGood) {
	return function (s0) {
		var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, isGood, s0.c, s0.t, s0.S, s0.b, s0.g);
		return (!(s0.c - s1.c)) ? A2(
			$stil4m$elm_syntax$ParserFast$Bad,
			false,
			A2($stil4m$elm_syntax$ParserFast$ExpectingAnyChar, s0.t, s0.S)) : A2(
			$stil4m$elm_syntax$ParserFast$Good,
			A3($elm$core$String$slice, s0.c, s1.c, s0.b),
			s1);
	};
};
var $stil4m$elm_syntax$Elm$Parser$Tokens$singleQuotedStringLiteralAfterDoubleQuote = A5(
	$stil4m$elm_syntax$ParserFast$loopUntil,
	A2($stil4m$elm_syntax$ParserFast$symbol, '\"', 0),
	A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'\\',
			$stil4m$elm_syntax$Elm$Parser$Tokens$escapedCharValueMap($elm$core$String$fromChar)),
		$stil4m$elm_syntax$ParserFast$atLeastOneWhileWithoutLinebreak(
			function (c) {
				switch (c) {
					case '\"':
						return false;
					case '\\':
						return false;
					default:
						return !$stil4m$elm_syntax$Char$Extra$isUtf16Surrogate(c);
				}
			})),
	'',
	F2(
		function (extension, soFar) {
			return soFar + (extension + '');
		}),
	$elm$core$Basics$identity);
var $stil4m$elm_syntax$Elm$Parser$Tokens$tripleQuotedStringLiteralOfterTripleDoubleQuote = A5(
	$stil4m$elm_syntax$ParserFast$loopUntil,
	A2($stil4m$elm_syntax$ParserFast$symbol, '\"\"\"', 0),
	A3(
		$stil4m$elm_syntax$ParserFast$oneOf3,
		A2($stil4m$elm_syntax$ParserFast$symbol, '\"', '\"'),
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'\\',
			$stil4m$elm_syntax$Elm$Parser$Tokens$escapedCharValueMap($elm$core$String$fromChar)),
		$stil4m$elm_syntax$ParserFast$atLeastOneWhile(
			function (c) {
				switch (c) {
					case '\"':
						return false;
					case '\\':
						return false;
					default:
						return !$stil4m$elm_syntax$Char$Extra$isUtf16Surrogate(c);
				}
			})),
	'',
	F2(
		function (extension, soFar) {
			return soFar + (extension + '');
		}),
	$elm$core$Basics$identity);
var $stil4m$elm_syntax$Elm$Parser$Tokens$singleOrTripleQuotedStringLiteralMapWithRange = function (rangeAndStringToRes) {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'\"',
		A4(
			$stil4m$elm_syntax$ParserFast$oneOf2MapWithStartRowColumnAndEndRowColumn,
			F5(
				function (startRow, startColumn, string, endRow, endColumn) {
					return A2(
						rangeAndStringToRes,
						{
							w: {p: endColumn, t: endRow},
							z: {p: startColumn - 1, t: startRow}
						},
						string);
				}),
			A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '\"\"', $stil4m$elm_syntax$Elm$Parser$Tokens$tripleQuotedStringLiteralOfterTripleDoubleQuote),
			F5(
				function (startRow, startColumn, string, endRow, endColumn) {
					return A2(
						rangeAndStringToRes,
						{
							w: {p: endColumn, t: endRow},
							z: {p: startColumn - 1, t: startRow}
						},
						string);
				}),
			$stil4m$elm_syntax$Elm$Parser$Tokens$singleQuotedStringLiteralAfterDoubleQuote));
};
var $stil4m$elm_syntax$Elm$Parser$Expression$literalExpression = $stil4m$elm_syntax$Elm$Parser$Tokens$singleOrTripleQuotedStringLiteralMapWithRange(
	F2(
		function (range, string) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Expression$Literal(string))
			};
		}));
var $stil4m$elm_syntax$ParserFast$loopWhileSucceedsOntoResultFromParser = F4(
	function (element, _v0, reduce, foldedToRes) {
		var parseInitialFolded = _v0;
		return function (s0) {
			var _v1 = parseInitialFolded(s0);
			if (!_v1.$) {
				var initialFolded = _v1.a;
				var s1 = _v1.b;
				return A5($stil4m$elm_syntax$ParserFast$loopWhileSucceedsHelp, element, initialFolded, reduce, foldedToRes, s1);
			} else {
				var committed = _v1.a;
				var x = _v1.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			}
		};
	});
var $stil4m$elm_syntax$Rope$prependTo = F2(
	function (right, left) {
		if (left.$ === 1) {
			return right;
		} else {
			var leftLikelyFilled = left.a;
			if (right.$ === 1) {
				return left;
			} else {
				var rightLikelyFilled = right.a;
				return $elm$core$Maybe$Just(
					A2($stil4m$elm_syntax$Rope$Branch2, leftLikelyFilled, rightLikelyFilled));
			}
		}
	});
var $stil4m$elm_syntax$ParserWithComments$many = function (p) {
	return A4(
		$stil4m$elm_syntax$ParserFast$loopWhileSucceeds,
		p,
		_Utils_Tuple2($stil4m$elm_syntax$Rope$empty, _List_Nil),
		F2(
			function (pResult, _v0) {
				var commentsSoFar = _v0.a;
				var itemsSoFar = _v0.b;
				return _Utils_Tuple2(
					A2($stil4m$elm_syntax$Rope$prependTo, pResult.ao, commentsSoFar),
					A2($elm$core$List$cons, pResult.a, itemsSoFar));
			}),
		function (_v1) {
			var commentsSoFar = _v1.a;
			var itemsSoFar = _v1.b;
			return {
				ao: commentsSoFar,
				a: $elm$core$List$reverse(itemsSoFar)
			};
		});
};
var $stil4m$elm_syntax$ParserWithComments$manyWithoutReverse = function (p) {
	return A4(
		$stil4m$elm_syntax$ParserFast$loopWhileSucceeds,
		p,
		_Utils_Tuple2($stil4m$elm_syntax$Rope$empty, _List_Nil),
		F2(
			function (pResult, _v0) {
				var commentsSoFar = _v0.a;
				var itemsSoFar = _v0.b;
				return _Utils_Tuple2(
					A2($stil4m$elm_syntax$Rope$prependTo, pResult.ao, commentsSoFar),
					A2($elm$core$List$cons, pResult.a, itemsSoFar));
			}),
		function (_v1) {
			var commentsSoFar = _v1.a;
			var itemsSoFar = _v1.b;
			return {ao: commentsSoFar, a: itemsSoFar};
		});
};
var $stil4m$elm_syntax$ParserFast$map = F2(
	function (func, _v0) {
		var parse = _v0;
		return function (s0) {
			var _v1 = parse(s0);
			if (!_v1.$) {
				var a = _v1.a;
				var s1 = _v1.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					func(a),
					s1);
			} else {
				var committed = _v1.a;
				var x = _v1.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map3 = F4(
	function (func, _v0, _v1, _v2) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		return function (s0) {
			var _v3 = parseA(s0);
			if (_v3.$ === 1) {
				var committed = _v3.a;
				var x = _v3.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v3.a;
				var s1 = _v3.b;
				var _v4 = parseB(s1);
				if (_v4.$ === 1) {
					var x = _v4.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v4.a;
					var s2 = _v4.b;
					var _v5 = parseC(s2);
					if (_v5.$ === 1) {
						var x = _v5.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v5.a;
						var s3 = _v5.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A3(func, a, b, c),
							s3);
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map3WithStartLocation = F4(
	function (func, _v0, _v1, _v2) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		return function (s0) {
			var _v3 = parseA(s0);
			if (_v3.$ === 1) {
				var committed = _v3.a;
				var x = _v3.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v3.a;
				var s1 = _v3.b;
				var _v4 = parseB(s1);
				if (_v4.$ === 1) {
					var x = _v4.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v4.a;
					var s2 = _v4.b;
					var _v5 = parseC(s2);
					if (_v5.$ === 1) {
						var x = _v5.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v5.a;
						var s3 = _v5.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A4(
								func,
								{p: s0.S, t: s0.t},
								a,
								b,
								c),
							s3);
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map4 = F5(
	function (func, _v0, _v1, _v2, _v3) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		return function (s0) {
			var _v4 = parseA(s0);
			if (_v4.$ === 1) {
				var committed = _v4.a;
				var x = _v4.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v4.a;
				var s1 = _v4.b;
				var _v5 = parseB(s1);
				if (_v5.$ === 1) {
					var x = _v5.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v5.a;
					var s2 = _v5.b;
					var _v6 = parseC(s2);
					if (_v6.$ === 1) {
						var x = _v6.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v6.a;
						var s3 = _v6.b;
						var _v7 = parseD(s3);
						if (_v7.$ === 1) {
							var x = _v7.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v7.a;
							var s4 = _v7.b;
							return A2(
								$stil4m$elm_syntax$ParserFast$Good,
								A4(func, a, b, c, d),
								s4);
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map4OrSucceed = F6(
	function (func, _v0, _v1, _v2, _v3, fallback) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		return function (s0) {
			var _v4 = parseA(s0);
			if (_v4.$ === 1) {
				var c1 = _v4.a;
				var x = _v4.b;
				return c1 ? A2($stil4m$elm_syntax$ParserFast$Bad, true, x) : A2($stil4m$elm_syntax$ParserFast$Good, fallback, s0);
			} else {
				var a = _v4.a;
				var s1 = _v4.b;
				var _v5 = parseB(s1);
				if (_v5.$ === 1) {
					var x = _v5.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v5.a;
					var s2 = _v5.b;
					var _v6 = parseC(s2);
					if (_v6.$ === 1) {
						var x = _v6.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v6.a;
						var s3 = _v6.b;
						var _v7 = parseD(s3);
						if (_v7.$ === 1) {
							var x = _v7.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v7.a;
							var s4 = _v7.b;
							return A2(
								$stil4m$elm_syntax$ParserFast$Good,
								A4(func, a, b, c, d),
								s4);
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map4WithRange = F5(
	function (func, _v0, _v1, _v2, _v3) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		return function (s0) {
			var _v4 = parseA(s0);
			if (_v4.$ === 1) {
				var committed = _v4.a;
				var x = _v4.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v4.a;
				var s1 = _v4.b;
				var _v5 = parseB(s1);
				if (_v5.$ === 1) {
					var x = _v5.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v5.a;
					var s2 = _v5.b;
					var _v6 = parseC(s2);
					if (_v6.$ === 1) {
						var x = _v6.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v6.a;
						var s3 = _v6.b;
						var _v7 = parseD(s3);
						if (_v7.$ === 1) {
							var x = _v7.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v7.a;
							var s4 = _v7.b;
							return A2(
								$stil4m$elm_syntax$ParserFast$Good,
								A5(
									func,
									{
										w: {p: s4.S, t: s4.t},
										z: {p: s0.S, t: s0.t}
									},
									a,
									b,
									c,
									d),
								s4);
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map5 = F6(
	function (func, _v0, _v1, _v2, _v3, _v4) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		return function (s0) {
			var _v5 = parseA(s0);
			if (_v5.$ === 1) {
				var committed = _v5.a;
				var x = _v5.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v5.a;
				var s1 = _v5.b;
				var _v6 = parseB(s1);
				if (_v6.$ === 1) {
					var x = _v6.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v6.a;
					var s2 = _v6.b;
					var _v7 = parseC(s2);
					if (_v7.$ === 1) {
						var x = _v7.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v7.a;
						var s3 = _v7.b;
						var _v8 = parseD(s3);
						if (_v8.$ === 1) {
							var x = _v8.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v8.a;
							var s4 = _v8.b;
							var _v9 = parseE(s4);
							if (_v9.$ === 1) {
								var x = _v9.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v9.a;
								var s5 = _v9.b;
								return A2(
									$stil4m$elm_syntax$ParserFast$Good,
									A5(func, a, b, c, d, e),
									s5);
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map5WithRange = F6(
	function (func, _v0, _v1, _v2, _v3, _v4) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		return function (s0) {
			var _v5 = parseA(s0);
			if (_v5.$ === 1) {
				var committed = _v5.a;
				var x = _v5.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v5.a;
				var s1 = _v5.b;
				var _v6 = parseB(s1);
				if (_v6.$ === 1) {
					var x = _v6.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v6.a;
					var s2 = _v6.b;
					var _v7 = parseC(s2);
					if (_v7.$ === 1) {
						var x = _v7.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v7.a;
						var s3 = _v7.b;
						var _v8 = parseD(s3);
						if (_v8.$ === 1) {
							var x = _v8.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v8.a;
							var s4 = _v8.b;
							var _v9 = parseE(s4);
							if (_v9.$ === 1) {
								var x = _v9.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v9.a;
								var s5 = _v9.b;
								return A2(
									$stil4m$elm_syntax$ParserFast$Good,
									A6(
										func,
										{
											w: {p: s5.S, t: s5.t},
											z: {p: s0.S, t: s0.t}
										},
										a,
										b,
										c,
										d,
										e),
									s5);
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map5WithStartLocation = F6(
	function (func, _v0, _v1, _v2, _v3, _v4) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		return function (s0) {
			var _v5 = parseA(s0);
			if (_v5.$ === 1) {
				var committed = _v5.a;
				var x = _v5.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v5.a;
				var s1 = _v5.b;
				var _v6 = parseB(s1);
				if (_v6.$ === 1) {
					var x = _v6.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v6.a;
					var s2 = _v6.b;
					var _v7 = parseC(s2);
					if (_v7.$ === 1) {
						var x = _v7.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v7.a;
						var s3 = _v7.b;
						var _v8 = parseD(s3);
						if (_v8.$ === 1) {
							var x = _v8.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v8.a;
							var s4 = _v8.b;
							var _v9 = parseE(s4);
							if (_v9.$ === 1) {
								var x = _v9.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v9.a;
								var s5 = _v9.b;
								return A2(
									$stil4m$elm_syntax$ParserFast$Good,
									A6(
										func,
										{p: s0.S, t: s0.t},
										a,
										b,
										c,
										d,
										e),
									s5);
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map6WithStartLocation = F7(
	function (func, _v0, _v1, _v2, _v3, _v4, _v5) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		var parseF = _v5;
		return function (s0) {
			var _v6 = parseA(s0);
			if (_v6.$ === 1) {
				var committed = _v6.a;
				var x = _v6.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v6.a;
				var s1 = _v6.b;
				var _v7 = parseB(s1);
				if (_v7.$ === 1) {
					var x = _v7.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v7.a;
					var s2 = _v7.b;
					var _v8 = parseC(s2);
					if (_v8.$ === 1) {
						var x = _v8.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v8.a;
						var s3 = _v8.b;
						var _v9 = parseD(s3);
						if (_v9.$ === 1) {
							var x = _v9.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v9.a;
							var s4 = _v9.b;
							var _v10 = parseE(s4);
							if (_v10.$ === 1) {
								var x = _v10.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v10.a;
								var s5 = _v10.b;
								var _v11 = parseF(s5);
								if (_v11.$ === 1) {
									var x = _v11.b;
									return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
								} else {
									var f = _v11.a;
									var s6 = _v11.b;
									return A2(
										$stil4m$elm_syntax$ParserFast$Good,
										A7(
											func,
											{p: s0.S, t: s0.t},
											a,
											b,
											c,
											d,
											e,
											f),
										s6);
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map8WithStartLocation = F9(
	function (func, _v0, _v1, _v2, _v3, _v4, _v5, _v6, _v7) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		var parseF = _v5;
		var parseG = _v6;
		var parseH = _v7;
		return function (s0) {
			var _v8 = parseA(s0);
			if (_v8.$ === 1) {
				var committed = _v8.a;
				var x = _v8.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v8.a;
				var s1 = _v8.b;
				var _v9 = parseB(s1);
				if (_v9.$ === 1) {
					var x = _v9.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v9.a;
					var s2 = _v9.b;
					var _v10 = parseC(s2);
					if (_v10.$ === 1) {
						var x = _v10.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v10.a;
						var s3 = _v10.b;
						var _v11 = parseD(s3);
						if (_v11.$ === 1) {
							var x = _v11.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v11.a;
							var s4 = _v11.b;
							var _v12 = parseE(s4);
							if (_v12.$ === 1) {
								var x = _v12.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v12.a;
								var s5 = _v12.b;
								var _v13 = parseF(s5);
								if (_v13.$ === 1) {
									var x = _v13.b;
									return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
								} else {
									var f = _v13.a;
									var s6 = _v13.b;
									var _v14 = parseG(s6);
									if (_v14.$ === 1) {
										var x = _v14.b;
										return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
									} else {
										var g = _v14.a;
										var s7 = _v14.b;
										var _v15 = parseH(s7);
										if (_v15.$ === 1) {
											var x = _v15.b;
											return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
										} else {
											var h = _v15.a;
											var s8 = _v15.b;
											return A2(
												$stil4m$elm_syntax$ParserFast$Good,
												A9(
													func,
													{p: s0.S, t: s0.t},
													a,
													b,
													c,
													d,
													e,
													f,
													g,
													h),
												s8);
										}
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$validateEndColumnIndentation = F3(
	function (isOkay, problemOnIsNotOkay, _v0) {
		var parse = _v0;
		return function (s0) {
			var _v1 = parse(s0);
			if (!_v1.$) {
				var good = _v1;
				var s1 = good.b;
				return A2(isOkay, s1.S, s1.g) ? good : A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					true,
					A3($stil4m$elm_syntax$ParserFast$ExpectingCustom, s1.t, s1.S, problemOnIsNotOkay));
			} else {
				var bad = _v1;
				return bad;
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Layout$endsPositivelyIndented = function (parser) {
	return A3(
		$stil4m$elm_syntax$ParserFast$validateEndColumnIndentation,
		F2(
			function (column, indent) {
				return _Utils_cmp(column, indent) > 0;
			}),
		'must be positively indented',
		parser);
};
var $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout = $stil4m$elm_syntax$Elm$Parser$Layout$endsPositivelyIndented($stil4m$elm_syntax$Elm$Parser$Layout$whitespaceAndCommentsOrEmpty);
var $stil4m$elm_syntax$Elm$Parser$Layout$maybeAroundBothSides = function (x) {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (before, v, after) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						after,
						A2($stil4m$elm_syntax$Rope$prependTo, v.ao, before)),
					a: v.a
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		x,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout);
};
var $stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccess = A4(
	$stil4m$elm_syntax$ParserFast$loopWhileSucceeds,
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '.', $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode),
	_List_Nil,
	$elm$core$List$cons,
	$elm$core$List$reverse);
var $stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccessMap = function (fieldsToRes) {
	return A4(
		$stil4m$elm_syntax$ParserFast$loopWhileSucceeds,
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '.', $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode),
		_List_Nil,
		$elm$core$List$cons,
		function (reversed) {
			return fieldsToRes(
				$elm$core$List$reverse(reversed));
		});
};
var $stil4m$elm_syntax$Elm$Parser$Expression$negationWhitespaceProblem = $stil4m$elm_syntax$ParserFast$problem('if a negation sign is not preceded by whitespace, it\'s considered subtraction');
var $stil4m$elm_syntax$Elm$Parser$Tokens$equal = A2($stil4m$elm_syntax$ParserFast$symbol, '=', 0);
var $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithAs = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithCons = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithNothing = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$ParserFast$symbolWithRange = F2(
	function (str, startAndEndLocationToRes) {
		var strLength = $elm$core$String$length(str);
		return function (s) {
			var newOffset = s.c + strLength;
			if (_Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				str + '')) {
				var newCol = s.S + strLength;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					startAndEndLocationToRes(
						{
							w: {p: newCol, t: s.t},
							z: {p: s.S, t: s.t}
						}),
					{S: newCol, g: s.g, c: newOffset, t: s.t, b: s.b});
			} else {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s.t, s.S, str));
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Patterns$allPattern = A2(
	$stil4m$elm_syntax$ParserFast$symbolWithRange,
	'_',
	function (range) {
		return {
			ao: $stil4m$elm_syntax$Rope$empty,
			a: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, $stil4m$elm_syntax$Elm$Syntax$Pattern$AllPattern)
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Patterns$charPattern = $stil4m$elm_syntax$Elm$Parser$Tokens$characterLiteralMapWithRange(
	F2(
		function (range, _char) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$CharPattern(_char))
			};
		}));
var $stil4m$elm_syntax$ParserFast$ExpectingNumber = F2(
	function (a, b) {
		return {$: 0, a: a, b: b};
	});
var $stil4m$elm_syntax$ParserFast$Decimal = 0;
var $stil4m$elm_syntax$ParserFast$Hexadecimal = 1;
var $stil4m$elm_syntax$ParserFast$convert0OrMore0To9s = F3(
	function (soFar, offset, src) {
		convert0OrMore0To9s:
		while (true) {
			var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
			switch (_v0) {
				case '0':
					var $temp$soFar = soFar * 10,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '1':
					var $temp$soFar = (soFar * 10) + 1,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '2':
					var $temp$soFar = (soFar * 10) + 2,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '3':
					var $temp$soFar = (soFar * 10) + 3,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '4':
					var $temp$soFar = (soFar * 10) + 4,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '5':
					var $temp$soFar = (soFar * 10) + 5,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '6':
					var $temp$soFar = (soFar * 10) + 6,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '7':
					var $temp$soFar = (soFar * 10) + 7,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '8':
					var $temp$soFar = (soFar * 10) + 8,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				case '9':
					var $temp$soFar = (soFar * 10) + 9,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMore0To9s;
				default:
					return {_: soFar, c: offset};
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal = F3(
	function (soFar, offset, src) {
		convert0OrMoreHexadecimal:
		while (true) {
			var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
			switch (_v0) {
				case '0':
					var $temp$soFar = soFar * 16,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '1':
					var $temp$soFar = (soFar * 16) + 1,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '2':
					var $temp$soFar = (soFar * 16) + 2,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '3':
					var $temp$soFar = (soFar * 16) + 3,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '4':
					var $temp$soFar = (soFar * 16) + 4,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '5':
					var $temp$soFar = (soFar * 16) + 5,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '6':
					var $temp$soFar = (soFar * 16) + 6,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '7':
					var $temp$soFar = (soFar * 16) + 7,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '8':
					var $temp$soFar = (soFar * 16) + 8,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case '9':
					var $temp$soFar = (soFar * 16) + 9,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'a':
					var $temp$soFar = (soFar * 16) + 10,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'A':
					var $temp$soFar = (soFar * 16) + 10,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'b':
					var $temp$soFar = (soFar * 16) + 11,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'B':
					var $temp$soFar = (soFar * 16) + 11,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'c':
					var $temp$soFar = (soFar * 16) + 12,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'C':
					var $temp$soFar = (soFar * 16) + 12,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'd':
					var $temp$soFar = (soFar * 16) + 13,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'D':
					var $temp$soFar = (soFar * 16) + 13,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'e':
					var $temp$soFar = (soFar * 16) + 14,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'E':
					var $temp$soFar = (soFar * 16) + 14,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'f':
					var $temp$soFar = (soFar * 16) + 15,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				case 'F':
					var $temp$soFar = (soFar * 16) + 15,
						$temp$offset = offset + 1,
						$temp$src = src;
					soFar = $temp$soFar;
					offset = $temp$offset;
					src = $temp$src;
					continue convert0OrMoreHexadecimal;
				default:
					return {_: soFar, c: offset};
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$convert1OrMoreHexadecimal = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '0':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 0, offset + 1, src);
			case '1':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 1, offset + 1, src);
			case '2':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 2, offset + 1, src);
			case '3':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 3, offset + 1, src);
			case '4':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 4, offset + 1, src);
			case '5':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 5, offset + 1, src);
			case '6':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 6, offset + 1, src);
			case '7':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 7, offset + 1, src);
			case '8':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 8, offset + 1, src);
			case '9':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 9, offset + 1, src);
			case 'a':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 10, offset + 1, src);
			case 'A':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 10, offset + 1, src);
			case 'b':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 11, offset + 1, src);
			case 'B':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 11, offset + 1, src);
			case 'c':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 12, offset + 1, src);
			case 'C':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 12, offset + 1, src);
			case 'd':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 13, offset + 1, src);
			case 'D':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 13, offset + 1, src);
			case 'e':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 14, offset + 1, src);
			case 'E':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 14, offset + 1, src);
			case 'f':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 15, offset + 1, src);
			case 'F':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMoreHexadecimal, 15, offset + 1, src);
			default:
				return {_: 0, c: -1};
		}
	});
var $stil4m$elm_syntax$ParserFast$errorAsBaseOffsetAndInt = {
	n: 0,
	j: {_: 0, c: -1}
};
var $stil4m$elm_syntax$ParserFast$convertIntegerDecimalOrHexadecimal = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '0':
				var _v1 = A3($elm$core$String$slice, offset + 1, offset + 2, src);
				if (_v1 === 'x') {
					var hex = A2($stil4m$elm_syntax$ParserFast$convert1OrMoreHexadecimal, offset + 2, src);
					return {
						n: 1,
						j: {_: hex._, c: hex.c}
					};
				} else {
					return {
						n: 0,
						j: {_: 0, c: offset + 1}
					};
				}
			case '1':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 1, offset + 1, src)
				};
			case '2':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 2, offset + 1, src)
				};
			case '3':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 3, offset + 1, src)
				};
			case '4':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 4, offset + 1, src)
				};
			case '5':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 5, offset + 1, src)
				};
			case '6':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 6, offset + 1, src)
				};
			case '7':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 7, offset + 1, src)
				};
			case '8':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 8, offset + 1, src)
				};
			case '9':
				return {
					n: 0,
					j: A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 9, offset + 1, src)
				};
			default:
				return $stil4m$elm_syntax$ParserFast$errorAsBaseOffsetAndInt;
		}
	});
var $stil4m$elm_syntax$ParserFast$integerDecimalOrHexadecimalMapWithRange = F2(
	function (rangeAndIntDecimalToRes, rangeAndIntHexadecimalToRes) {
		return function (s0) {
			var s1 = A2($stil4m$elm_syntax$ParserFast$convertIntegerDecimalOrHexadecimal, s0.c, s0.b);
			if (_Utils_eq(s1.j.c, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingNumber, s0.t, s0.S));
			} else {
				var newColumn = s0.S + (s1.j.c - s0.c);
				var range = {
					w: {p: newColumn, t: s0.t},
					z: {p: s0.S, t: s0.t}
				};
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					function () {
						var _v0 = s1.n;
						if (!_v0) {
							return A2(rangeAndIntDecimalToRes, range, s1.j._);
						} else {
							return A2(rangeAndIntHexadecimalToRes, range, s1.j._);
						}
					}(),
					{S: newColumn, g: s0.g, c: s1.j.c, t: s0.t, b: s0.b});
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Patterns$numberPart = A2(
	$stil4m$elm_syntax$ParserFast$integerDecimalOrHexadecimalMapWithRange,
	F2(
		function (range, n) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$IntPattern(n))
			};
		}),
	F2(
		function (range, n) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$HexPattern(n))
			};
		}));
var $stil4m$elm_syntax$ParserFast$oneOf2OrSucceed = F3(
	function (_v0, _v1, thirdRes) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		return function (s) {
			var _v2 = attemptFirst(s);
			if (!_v2.$) {
				var firstGood = _v2;
				return firstGood;
			} else {
				var firstBad = _v2;
				var firstCommitted = firstBad.a;
				if (firstCommitted) {
					return firstBad;
				} else {
					var _v3 = attemptSecond(s);
					if (!_v3.$) {
						var secondGood = _v3;
						return secondGood;
					} else {
						var secondBad = _v3;
						var secondCommitted = secondBad.a;
						return secondCommitted ? secondBad : A2($stil4m$elm_syntax$ParserFast$Good, thirdRes, s);
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$oneOf9 = F9(
	function (_v0, _v1, _v2, _v3, _v4, _v5, _v6, _v7, _v8) {
		var attempt0 = _v0;
		var attempt1 = _v1;
		var attempt2 = _v2;
		var attempt3 = _v3;
		var attempt4 = _v4;
		var attempt5 = _v5;
		var attempt6 = _v6;
		var attempt7 = _v7;
		var attempt8 = _v8;
		return function (s) {
			var _v9 = attempt0(s);
			if (!_v9.$) {
				var good = _v9;
				return good;
			} else {
				var bad0 = _v9;
				var committed0 = bad0.a;
				var x0 = bad0.b;
				if (committed0) {
					return bad0;
				} else {
					var _v10 = attempt1(s);
					if (!_v10.$) {
						var good = _v10;
						return good;
					} else {
						var bad1 = _v10;
						var committed1 = bad1.a;
						var x1 = bad1.b;
						if (committed1) {
							return bad1;
						} else {
							var _v11 = attempt2(s);
							if (!_v11.$) {
								var good = _v11;
								return good;
							} else {
								var bad2 = _v11;
								var committed2 = bad2.a;
								var x2 = bad2.b;
								if (committed2) {
									return bad2;
								} else {
									var _v12 = attempt3(s);
									if (!_v12.$) {
										var good = _v12;
										return good;
									} else {
										var bad3 = _v12;
										var committed3 = bad3.a;
										var x3 = bad3.b;
										if (committed3) {
											return bad3;
										} else {
											var _v13 = attempt4(s);
											if (!_v13.$) {
												var good = _v13;
												return good;
											} else {
												var bad4 = _v13;
												var committed4 = bad4.a;
												var x4 = bad4.b;
												if (committed4) {
													return bad4;
												} else {
													var _v14 = attempt5(s);
													if (!_v14.$) {
														var good = _v14;
														return good;
													} else {
														var bad5 = _v14;
														var committed5 = bad5.a;
														var x5 = bad5.b;
														if (committed5) {
															return bad5;
														} else {
															var _v15 = attempt6(s);
															if (!_v15.$) {
																var good = _v15;
																return good;
															} else {
																var bad6 = _v15;
																var committed6 = bad6.a;
																var x6 = bad6.b;
																if (committed6) {
																	return bad6;
																} else {
																	var _v16 = attempt7(s);
																	if (!_v16.$) {
																		var good = _v16;
																		return good;
																	} else {
																		var bad7 = _v16;
																		var committed7 = bad7.a;
																		var x7 = bad7.b;
																		if (committed7) {
																			return bad7;
																		} else {
																			var _v17 = attempt8(s);
																			if (!_v17.$) {
																				var good = _v17;
																				return good;
																			} else {
																				var bad8 = _v17;
																				var committed8 = bad8.a;
																				var x8 = bad8.b;
																				return committed8 ? bad8 : A2(
																					$stil4m$elm_syntax$ParserFast$Bad,
																					false,
																					A3(
																						$stil4m$elm_syntax$ParserFast$ExpectingOneOf,
																						x0,
																						x1,
																						_List_fromArray(
																							[x2, x3, x4, x5, x6, x7, x8])));
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Patterns$patternListEmpty = $stil4m$elm_syntax$Elm$Syntax$Pattern$ListPattern(_List_Nil);
var $stil4m$elm_syntax$Elm$Parser$Layout$problemPositivelyIndented = $stil4m$elm_syntax$ParserFast$problem('must be positively indented');
var $stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy = function (nextParser) {
	return $stil4m$elm_syntax$ParserFast$columnIndentAndThen(
		F2(
			function (column, indent) {
				return (_Utils_cmp(column, indent) > 0) ? nextParser : $stil4m$elm_syntax$Elm$Parser$Layout$problemPositivelyIndented;
			}));
};
var $stil4m$elm_syntax$ParserFast$ifFollowedByWhileWithoutLinebreak = F2(
	function (firstIsOkay, afterFirstIsOkay) {
		return function (s) {
			var firstOffset = A3($stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak, firstIsOkay, s.c, s.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate, s.t, s.S));
			} else {
				var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, afterFirstIsOkay, firstOffset, s.t, s.S + 1, s.b, s.g);
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A3($elm$core$String$slice, s.c, s1.c, s.b),
					s1);
			}
		};
	});
var $stil4m$elm_syntax$Char$Extra$unicodeIsUpperFast = function (c) {
	var code = $elm$core$Char$toCode(c);
	return $stil4m$elm_syntax$Char$Extra$charCodeIsUpper(code) || function () {
		var cString = $elm$core$String$fromChar(c);
		return (_Utils_eq(
			$elm$core$String$toUpper(cString),
			cString + '') && (!_Utils_eq(
			$elm$core$String$toLower(cString),
			cString + ''))) ? ((code <= 8543) || (((8560 <= code) && (code <= 9397)) || ((9424 <= code) && (code <= 983040)))) : ((code < 120015) ? ((code < 8509) ? (((978 <= code) && (code <= 980)) || ((code === 8450) || ((code === 8455) || (((8459 <= code) && (code <= 8461)) || (((8464 <= code) && (code <= 8466)) || ((code === 8469) || (((8473 <= code) && (code <= 8477)) || ((code === 8484) || ((code === 8488) || (((8490 <= code) && (code <= 8493)) || ((8496 <= code) && (code <= 8499)))))))))))) : (((8510 <= code) && (code <= 8511)) || ((code === 8517) || (((119808 <= code) && (code <= 119833)) || (((119860 <= code) && (code <= 119885)) || (((119912 <= code) && (code <= 119937)) || ((code === 119964) || (((119966 <= code) && (code <= 119967)) || ((code === 119970) || (((119973 <= code) && (code <= 119974)) || (((119977 <= code) && (code <= 119980)) || ((119982 <= code) && (code <= 119989))))))))))))) : ((code < 120223) ? (((120016 <= code) && (code <= 120041)) || (((120068 <= code) && (code <= 120069)) || (((120071 <= code) && (code <= 120074)) || (((120077 <= code) && (code <= 120084)) || (((120086 <= code) && (code <= 120092)) || (((120120 <= code) && (code <= 120121)) || (((120123 <= code) && (code <= 120126)) || (((120128 <= code) && (code <= 120132)) || ((code === 120134) || (((120138 <= code) && (code <= 120144)) || ((120172 <= code) && (code <= 120197)))))))))))) : (((120224 <= code) && (code <= 120249)) || (((120276 <= code) && (code <= 120301)) || (((120328 <= code) && (code <= 120353)) || (((120380 <= code) && (code <= 120405)) || (((120432 <= code) && (code <= 120457)) || (((120488 <= code) && (code <= 120512)) || (((120546 <= code) && (code <= 120570)) || (((120604 <= code) && (code <= 120628)) || (((120662 <= code) && (code <= 120686)) || (((120720 <= code) && (code <= 120744)) || (code === 120778)))))))))))));
	}();
};
var $stil4m$elm_syntax$Elm$Parser$Tokens$typeName = A2($stil4m$elm_syntax$ParserFast$ifFollowedByWhileWithoutLinebreak, $stil4m$elm_syntax$Char$Extra$unicodeIsUpperFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast);
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeDotTypeNamesTuple() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map2OrSucceed,
		F2(
			function (startName, afterStartName) {
				if (afterStartName.$ === 1) {
					return $elm$core$Maybe$Just(
						_Utils_Tuple2(_List_Nil, startName));
				} else {
					var _v1 = afterStartName.a;
					var qualificationAfter = _v1.a;
					var unqualified = _v1.b;
					return $elm$core$Maybe$Just(
						_Utils_Tuple2(
							A2($elm$core$List$cons, startName, qualificationAfter),
							unqualified));
				}
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '.', $stil4m$elm_syntax$Elm$Parser$Tokens$typeName),
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v2) {
				return $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeDotTypeNamesTuple();
			}),
		$elm$core$Maybe$Nothing);
}
var $stil4m$elm_syntax$Elm$Parser$Patterns$maybeDotTypeNamesTuple = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeDotTypeNamesTuple();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeDotTypeNamesTuple = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$maybeDotTypeNamesTuple;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedNameRefNode = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, firstName, after) {
			return A2(
				$stil4m$elm_syntax$Elm$Syntax$Node$Node,
				range,
				function () {
					if (after.$ === 1) {
						return {H: _List_Nil, N: firstName};
					} else {
						var _v1 = after.a;
						var qualificationAfter = _v1.a;
						var unqualified = _v1.b;
						return {
							H: A2($elm$core$List$cons, firstName, qualificationAfter),
							N: unqualified
						};
					}
				}());
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
	$stil4m$elm_syntax$Elm$Parser$Patterns$maybeDotTypeNamesTuple);
var $stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedPatternWithoutConsumeArgs = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, firstName, after) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					A2(
						$stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern,
						function () {
							if (after.$ === 1) {
								return {H: _List_Nil, N: firstName};
							} else {
								var _v1 = after.a;
								var qualificationAfter = _v1.a;
								var unqualified = _v1.b;
								return {
									H: A2($elm$core$List$cons, firstName, qualificationAfter),
									N: unqualified
								};
							}
						}(),
						_List_Nil))
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
	$stil4m$elm_syntax$Elm$Parser$Patterns$maybeDotTypeNamesTuple);
var $stil4m$elm_syntax$Elm$Parser$Patterns$recordPattern = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, commentsBeforeElements, elements) {
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, elements.ao, commentsBeforeElements),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$RecordPattern(elements.a))
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '{', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		A2(
			$stil4m$elm_syntax$ParserFast$followedBySymbol,
			'}',
			A4(
				$stil4m$elm_syntax$ParserFast$map3,
				F3(
					function (head, commentsAfterHead, tail) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, tail.ao, commentsAfterHead),
							a: A2($elm$core$List$cons, head, tail.a)
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$ParserWithComments$many(
					A2(
						$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
						',',
						A4(
							$stil4m$elm_syntax$ParserFast$map3,
							F3(
								function (beforeName, name, afterName) {
									return {
										ao: A2($stil4m$elm_syntax$Rope$prependTo, afterName, beforeName),
										a: name
									};
								}),
							$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
							$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
							$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))))),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'}',
			{ao: $stil4m$elm_syntax$Rope$empty, a: _List_Nil})));
var $stil4m$elm_syntax$Elm$Parser$Patterns$stringPattern = $stil4m$elm_syntax$Elm$Parser$Tokens$singleOrTripleQuotedStringLiteralMapWithRange(
	F2(
		function (range, string) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$StringPattern(string))
			};
		}));
var $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange = function (rangeAndNameToResult) {
	return A4($stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateMapWithRangeWithoutLinebreak, rangeAndNameToResult, $stil4m$elm_syntax$Char$Extra$unicodeIsLowerFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast, $stil4m$elm_syntax$Elm$Parser$Tokens$isNotReserved);
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$varPattern = $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange(
	F2(
		function (range, _var) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Pattern$VarPattern(_var))
			};
		}));
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePatternTryToCompose() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (x, commentsAfterLeft, maybeComposedWithResult) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						maybeComposedWithResult.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterLeft, x.ao)),
					a: function () {
						var _v7 = maybeComposedWithResult.a;
						switch (_v7.$) {
							case 0:
								return x.a;
							case 1:
								var anotherName = _v7.a;
								return A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$Pattern$AsPattern, x.a, anotherName);
							default:
								var y = _v7.a;
								return A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$Pattern$UnConsPattern, x.a, y);
						}
					}()
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePattern(),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeComposedWith());
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePattern() {
	return A9(
		$stil4m$elm_syntax$ParserFast$oneOf9,
		$stil4m$elm_syntax$Elm$Parser$Patterns$varPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$qualifiedPatternWithConsumeArgs(),
		$stil4m$elm_syntax$Elm$Parser$Patterns$allPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$parensPattern(),
		$stil4m$elm_syntax$Elm$Parser$Patterns$recordPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$stringPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$listPattern(),
		$stil4m$elm_syntax$Elm$Parser$Patterns$numberPart,
		$stil4m$elm_syntax$Elm$Parser$Patterns$charPattern);
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$qualifiedPatternWithConsumeArgs() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (_v4, afterStartName, argsReverse) {
				var nameRange = _v4.a;
				var name = _v4.b;
				var range = function () {
					var _v5 = argsReverse.a;
					if (!_v5.b) {
						return nameRange;
					} else {
						var _v6 = _v5.a;
						var lastArgRange = _v6.a;
						return {w: lastArgRange.w, z: nameRange.z};
					}
				}();
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, argsReverse.ao, afterStartName),
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						A2(
							$stil4m$elm_syntax$Elm$Syntax$Pattern$NamedPattern,
							name,
							$elm$core$List$reverse(argsReverse.a)))
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedNameRefNode,
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
			$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy(
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (arg, commentsAfterArg) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterArg, arg.ao),
								a: arg.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$patternNotDirectlyComposing(),
					$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout))));
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$patternNotDirectlyComposing() {
	return A9(
		$stil4m$elm_syntax$ParserFast$oneOf9,
		$stil4m$elm_syntax$Elm$Parser$Patterns$varPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedPatternWithoutConsumeArgs,
		$stil4m$elm_syntax$Elm$Parser$Patterns$allPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$parensPattern(),
		$stil4m$elm_syntax$Elm$Parser$Patterns$recordPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$stringPattern,
		$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$listPattern(),
		$stil4m$elm_syntax$Elm$Parser$Patterns$numberPart,
		$stil4m$elm_syntax$Elm$Parser$Patterns$charPattern);
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$listPattern() {
	return A3(
		$stil4m$elm_syntax$ParserFast$map2WithRange,
		F3(
			function (range, commentsBeforeElements, maybeElements) {
				if (maybeElements.$ === 1) {
					return {
						ao: commentsBeforeElements,
						a: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, $stil4m$elm_syntax$Elm$Parser$Patterns$patternListEmpty)
					};
				} else {
					var elements = maybeElements.a;
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, elements.ao, commentsBeforeElements),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							range,
							$stil4m$elm_syntax$Elm$Syntax$Pattern$ListPattern(elements.a))
					};
				}
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '[', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		A2(
			$stil4m$elm_syntax$ParserFast$oneOf2,
			A2($stil4m$elm_syntax$ParserFast$symbol, ']', $elm$core$Maybe$Nothing),
			A2(
				$stil4m$elm_syntax$ParserFast$followedBySymbol,
				']',
				A4(
					$stil4m$elm_syntax$ParserFast$map3,
					F3(
						function (head, commentsAfterHead, tail) {
							return $elm$core$Maybe$Just(
								{
									ao: A2(
										$stil4m$elm_syntax$Rope$prependTo,
										commentsAfterHead,
										A2($stil4m$elm_syntax$Rope$prependTo, tail.ao, head.ao)),
									a: A2($elm$core$List$cons, head.a, tail.a)
								});
						}),
					$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern(),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$ParserWithComments$many(
						A2(
							$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
							',',
							$stil4m$elm_syntax$Elm$Parser$Layout$maybeAroundBothSides(
								$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern())))))));
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeComposedWith() {
	return A3(
		$stil4m$elm_syntax$ParserFast$oneOf2OrSucceed,
		A2(
			$stil4m$elm_syntax$ParserFast$keywordFollowedBy,
			'as',
			A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsAfterAs, name) {
						return {
							ao: commentsAfterAs,
							a: $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithAs(name)
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode)),
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'::',
			A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsAfterCons, patternResult) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, patternResult.ao, commentsAfterCons),
							a: $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithCons(patternResult.a)
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern())),
		{
			ao: $stil4m$elm_syntax$Rope$empty,
			a: $stil4m$elm_syntax$Elm$Parser$Patterns$PatternComposedWithNothing(0)
		});
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$parensPattern() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'(',
		A3(
			$stil4m$elm_syntax$ParserFast$map2WithRange,
			F3(
				function (range, commentsBeforeHead, contentResult) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, contentResult.ao, commentsBeforeHead),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: range.w,
								z: {p: range.z.p - 1, t: range.z.t}
							},
							contentResult.a)
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				A2(
					$stil4m$elm_syntax$ParserFast$symbol,
					')',
					{ao: $stil4m$elm_syntax$Rope$empty, a: $stil4m$elm_syntax$Elm$Syntax$Pattern$UnitPattern}),
				A4(
					$stil4m$elm_syntax$ParserFast$map3,
					F3(
						function (headResult, commentsAfterHead, tailResult) {
							return {
								ao: A2(
									$stil4m$elm_syntax$Rope$prependTo,
									tailResult.ao,
									A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterHead, headResult.ao)),
								a: function () {
									var _v1 = tailResult.a;
									if (_v1.$ === 1) {
										return $stil4m$elm_syntax$Elm$Syntax$Pattern$ParenthesizedPattern(headResult.a);
									} else {
										var secondAndMaybeThirdPart = _v1.a;
										var _v2 = secondAndMaybeThirdPart.ab;
										if (_v2.$ === 1) {
											return $stil4m$elm_syntax$Elm$Syntax$Pattern$TuplePattern(
												_List_fromArray(
													[headResult.a, secondAndMaybeThirdPart.O]));
										} else {
											var thirdPart = _v2.a;
											return $stil4m$elm_syntax$Elm$Syntax$Pattern$TuplePattern(
												_List_fromArray(
													[headResult.a, secondAndMaybeThirdPart.O, thirdPart]));
										}
									}
								}()
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern(),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					A2(
						$stil4m$elm_syntax$ParserFast$oneOf2,
						A2(
							$stil4m$elm_syntax$ParserFast$symbol,
							')',
							{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}),
						A2(
							$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
							',',
							A5(
								$stil4m$elm_syntax$ParserFast$map4,
								F4(
									function (commentsBefore, secondPart, commentsAfter, maybeThirdPart) {
										return {
											ao: A2(
												$stil4m$elm_syntax$Rope$prependTo,
												maybeThirdPart.ao,
												A2(
													$stil4m$elm_syntax$Rope$prependTo,
													commentsAfter,
													A2($stil4m$elm_syntax$Rope$prependTo, secondPart.ao, commentsBefore))),
											a: $elm$core$Maybe$Just(
												{ab: maybeThirdPart.a, O: secondPart.a})
										};
									}),
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
								$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern(),
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
								A2(
									$stil4m$elm_syntax$ParserFast$oneOf2,
									A2(
										$stil4m$elm_syntax$ParserFast$symbol,
										')',
										{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}),
									A2(
										$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
										',',
										A2(
											$stil4m$elm_syntax$ParserFast$followedBySymbol,
											')',
											A4(
												$stil4m$elm_syntax$ParserFast$map3,
												F3(
													function (commentsBefore, thirdPart, commentsAfter) {
														return {
															ao: A2(
																$stil4m$elm_syntax$Rope$prependTo,
																commentsAfter,
																A2($stil4m$elm_syntax$Rope$prependTo, thirdPart.ao, commentsBefore)),
															a: $elm$core$Maybe$Just(thirdPart.a)
														};
													}),
												$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
												$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern(),
												$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)))))))))));
}
function $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern() {
	return $stil4m$elm_syntax$ParserFast$lazy(
		function (_v0) {
			return $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePatternTryToCompose();
		});
}
var $stil4m$elm_syntax$Elm$Parser$Patterns$composablePatternTryToCompose = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePatternTryToCompose();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePatternTryToCompose = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$composablePatternTryToCompose;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$composablePattern = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePattern();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$composablePattern = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$composablePattern;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedPatternWithConsumeArgs = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$qualifiedPatternWithConsumeArgs();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$qualifiedPatternWithConsumeArgs = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$qualifiedPatternWithConsumeArgs;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$patternNotDirectlyComposing();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$patternNotDirectlyComposing = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$listPattern = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$listPattern();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$listPattern = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$listPattern;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$maybeComposedWith = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeComposedWith();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$maybeComposedWith = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$maybeComposedWith;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$parensPattern = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$parensPattern();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$parensPattern = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$parensPattern;
};
var $stil4m$elm_syntax$Elm$Parser$Patterns$pattern = $stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern();
$stil4m$elm_syntax$Elm$Parser$Patterns$cyclic$pattern = function () {
	return $stil4m$elm_syntax$Elm$Parser$Patterns$pattern;
};
var $stil4m$elm_syntax$ParserWithComments$until = F2(
	function (end, element) {
		return A5(
			$stil4m$elm_syntax$ParserFast$loopUntil,
			end,
			element,
			_Utils_Tuple2($stil4m$elm_syntax$Rope$empty, _List_Nil),
			F2(
				function (pResult, _v0) {
					var commentsSoFar = _v0.a;
					var itemsSoFar = _v0.b;
					return _Utils_Tuple2(
						A2($stil4m$elm_syntax$Rope$prependTo, pResult.ao, commentsSoFar),
						A2($elm$core$List$cons, pResult.a, itemsSoFar));
				}),
			function (_v1) {
				var commentsSoFar = _v1.a;
				var itemsSoFar = _v1.b;
				return {
					ao: commentsSoFar,
					a: $elm$core$List$reverse(itemsSoFar)
				};
			});
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$parameterPatternsEqual = A2(
	$stil4m$elm_syntax$ParserWithComments$until,
	$stil4m$elm_syntax$Elm$Parser$Tokens$equal,
	A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (patternResult, commentsAfterPattern) {
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterPattern, patternResult.ao),
					a: patternResult.a
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout));
var $stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedPlusFollowedBy = F2(
	function (extraIndent, nextParser) {
		return $stil4m$elm_syntax$ParserFast$columnIndentAndThen(
			F2(
				function (column, indent) {
					return (_Utils_cmp(column, indent + extraIndent) > 0) ? nextParser : $stil4m$elm_syntax$Elm$Parser$Layout$problemPositivelyIndented;
				}));
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$problemCannotMixNonAssociativeInfixOperators = $stil4m$elm_syntax$ParserFast$problem('cannot mix non-associative infix operators without parenthesis');
var $stil4m$elm_syntax$Elm$Parser$Expression$rangeMoveStartLeftByOneColumn = function (range) {
	return {
		w: range.w,
		z: {p: range.z.p - 1, t: range.z.t}
	};
};
var $stil4m$elm_syntax$Elm$Parser$Expression$recordAccessFunctionExpression = A2(
	$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
	'.',
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange(
		F2(
			function (range, field) {
				return {
					ao: $stil4m$elm_syntax$Rope$empty,
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						$stil4m$elm_syntax$Elm$Parser$Expression$rangeMoveStartLeftByOneColumn(range),
						$stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccessFunction('.' + field))
				};
			})));
var $stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9 = F2(
	function (offset, src) {
		skip0OrMoreDigits0To9:
		while (true) {
			var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
			switch (_v0) {
				case '0':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '1':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '2':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '3':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '4':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '5':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '6':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '7':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '8':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				case '9':
					var $temp$offset = offset + 1,
						$temp$src = src;
					offset = $temp$offset;
					src = $temp$src;
					continue skip0OrMoreDigits0To9;
				default:
					return offset;
			}
		}
	});
var $stil4m$elm_syntax$ParserFast$skip1OrMoreDigits0To9 = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '0':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '1':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '2':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '3':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '4':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '5':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '6':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '7':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '8':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			case '9':
				return A2($stil4m$elm_syntax$ParserFast$skip0OrMoreDigits0To9, offset + 1, src);
			default:
				return -1;
		}
	});
var $stil4m$elm_syntax$ParserFast$skipAfterFloatExponentMark = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '+':
				return A2($stil4m$elm_syntax$ParserFast$skip1OrMoreDigits0To9, offset + 1, src);
			case '-':
				return A2($stil4m$elm_syntax$ParserFast$skip1OrMoreDigits0To9, offset + 1, src);
			default:
				return A2($stil4m$elm_syntax$ParserFast$skip1OrMoreDigits0To9, offset, src);
		}
	});
var $stil4m$elm_syntax$ParserFast$skipFloatAfterIntegerDecimal = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '.':
				var offsetAfterDigits = A2($stil4m$elm_syntax$ParserFast$skip1OrMoreDigits0To9, offset + 1, src);
				if (_Utils_eq(offsetAfterDigits, -1)) {
					return -1;
				} else {
					var _v1 = A3($elm$core$String$slice, offsetAfterDigits, offsetAfterDigits + 1, src);
					switch (_v1) {
						case 'e':
							return A2($stil4m$elm_syntax$ParserFast$skipAfterFloatExponentMark, offsetAfterDigits + 1, src);
						case 'E':
							return A2($stil4m$elm_syntax$ParserFast$skipAfterFloatExponentMark, offsetAfterDigits + 1, src);
						default:
							return offsetAfterDigits;
					}
				}
			case 'e':
				return A2($stil4m$elm_syntax$ParserFast$skipAfterFloatExponentMark, offset + 1, src);
			case 'E':
				return A2($stil4m$elm_syntax$ParserFast$skipAfterFloatExponentMark, offset + 1, src);
			default:
				return -1;
		}
	});
var $elm$core$String$toFloat = _String_toFloat;
var $stil4m$elm_syntax$ParserFast$floatOrIntegerDecimalOrHexadecimalMapWithRange = F3(
	function (rangeAndFloatToRes, rangeAndIntDecimalToRes, rangeAndIntHexadecimalToRes) {
		return function (s0) {
			var s1 = A2($stil4m$elm_syntax$ParserFast$convertIntegerDecimalOrHexadecimal, s0.c, s0.b);
			if (_Utils_eq(s1.j.c, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingNumber, s0.t, s0.S));
			} else {
				var offsetAfterFloat = A2($stil4m$elm_syntax$ParserFast$skipFloatAfterIntegerDecimal, s1.j.c, s0.b);
				if (_Utils_eq(offsetAfterFloat, -1)) {
					var newColumn = s0.S + (s1.j.c - s0.c);
					var range = {
						w: {p: newColumn, t: s0.t},
						z: {p: s0.S, t: s0.t}
					};
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						function () {
							var _v0 = s1.n;
							if (!_v0) {
								return A2(rangeAndIntDecimalToRes, range, s1.j._);
							} else {
								return A2(rangeAndIntHexadecimalToRes, range, s1.j._);
							}
						}(),
						{S: newColumn, g: s0.g, c: s1.j.c, t: s0.t, b: s0.b});
				} else {
					var _v1 = $elm$core$String$toFloat(
						A3($elm$core$String$slice, s0.c, offsetAfterFloat, s0.b));
					if (!_v1.$) {
						var _float = _v1.a;
						var newColumn = s0.S + (offsetAfterFloat - s0.c);
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A2(
								rangeAndFloatToRes,
								{
									w: {p: newColumn, t: s0.t},
									z: {p: s0.S, t: s0.t}
								},
								_float),
							{S: newColumn, g: s0.g, c: offsetAfterFloat, t: s0.t, b: s0.b});
					} else {
						return A2(
							$stil4m$elm_syntax$ParserFast$Bad,
							false,
							A2($stil4m$elm_syntax$ParserFast$ExpectingNumber, s0.t, s0.S));
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$numberExpression = A3(
	$stil4m$elm_syntax$ParserFast$floatOrIntegerDecimalOrHexadecimalMapWithRange,
	F2(
		function (range, n) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Expression$Floatable(n))
			};
		}),
	F2(
		function (range, n) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Expression$Integer(n))
			};
		}),
	F2(
		function (range, n) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Expression$Hex(n))
			};
		}));
var $stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateWithoutLinebreak = F3(
	function (firstIsOkay, afterFirstIsOkay, resultIsOkay) {
		return function (s) {
			var firstOffset = A3($stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak, firstIsOkay, s.c, s.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate, s.t, s.S));
			} else {
				var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, afterFirstIsOkay, firstOffset, s.t, s.S + 1, s.b, s.g);
				var name = A3($elm$core$String$slice, s.c, s1.c, s.b);
				return resultIsOkay(name) ? A2($stil4m$elm_syntax$ParserFast$Good, name, s1) : A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingStringSatisfyingPredicate, s.t, s.S + 1));
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$functionName = A3($stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateWithoutLinebreak, $stil4m$elm_syntax$Char$Extra$unicodeIsLowerFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast, $stil4m$elm_syntax$Elm$Parser$Tokens$isNotReserved);
var $stil4m$elm_syntax$ParserFast$oneOf2Map = F4(
	function (firstToChoice, _v0, secondToChoice, _v1) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		return function (s) {
			var _v2 = attemptFirst(s);
			if (!_v2.$) {
				var first = _v2.a;
				var s1 = _v2.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					firstToChoice(first),
					s1);
			} else {
				var firstCommitted = _v2.a;
				var firstX = _v2.b;
				if (firstCommitted) {
					return A2($stil4m$elm_syntax$ParserFast$Bad, firstCommitted, firstX);
				} else {
					var _v3 = attemptSecond(s);
					if (!_v3.$) {
						var second = _v3.a;
						var s1 = _v3.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							secondToChoice(second),
							s1);
					} else {
						var secondCommitted = _v3.a;
						var secondX = _v3.b;
						return secondCommitted ? A2($stil4m$elm_syntax$ParserFast$Bad, secondCommitted, secondX) : A2(
							$stil4m$elm_syntax$ParserFast$Bad,
							false,
							A3($stil4m$elm_syntax$ParserFast$ExpectingOneOf, firstX, secondX, _List_Nil));
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$orSucceed = F2(
	function (_v0, secondRes) {
		var attemptFirst = _v0;
		return function (s) {
			var _v1 = attemptFirst(s);
			if (!_v1.$) {
				var firstGood = _v1;
				return firstGood;
			} else {
				var firstBad = _v1;
				var firstCommitted = firstBad.a;
				return firstCommitted ? firstBad : A2($stil4m$elm_syntax$ParserFast$Good, secondRes, s);
			}
		};
	});
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$maybeDotReferenceExpressionTuple() {
	return A2(
		$stil4m$elm_syntax$ParserFast$orSucceed,
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'.',
			A4(
				$stil4m$elm_syntax$ParserFast$oneOf2Map,
				$elm$core$Maybe$Just,
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (firstName, after) {
							if (after.$ === 1) {
								return _Utils_Tuple3(_List_Nil, firstName, _List_Nil);
							} else {
								var _v1 = after.a;
								var qualificationAfter = _v1.a;
								var unqualified = _v1.b;
								var recordAccess = _v1.c;
								return _Utils_Tuple3(
									A2($elm$core$List$cons, firstName, qualificationAfter),
									unqualified,
									recordAccess);
							}
						}),
					$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
					$stil4m$elm_syntax$ParserFast$lazy(
						function (_v2) {
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$maybeDotReferenceExpressionTuple();
						})),
				$elm$core$Basics$identity,
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (name, recordAccesses) {
							return $elm$core$Maybe$Just(
								_Utils_Tuple3(_List_Nil, name, recordAccesses));
						}),
					$stil4m$elm_syntax$Elm$Parser$Tokens$functionName,
					$stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccess))),
		$elm$core$Maybe$Nothing);
}
var $stil4m$elm_syntax$Elm$Parser$Expression$maybeDotReferenceExpressionTuple = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$maybeDotReferenceExpressionTuple();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$maybeDotReferenceExpressionTuple = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$maybeDotReferenceExpressionTuple;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$qualifiedOrVariantOrRecordConstructorReferenceExpressionFollowedByRecordAccess = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, firstName, after) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: function () {
					if (after.$ === 1) {
						return A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							range,
							A2($stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue, _List_Nil, firstName));
					} else {
						var _v1 = after.a;
						var qualificationAfter = _v1.a;
						var unqualified = _v1.b;
						var recordAccesses = _v1.c;
						if (!recordAccesses.b) {
							return A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								range,
								A2(
									$stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue,
									A2($elm$core$List$cons, firstName, qualificationAfter),
									unqualified));
						} else {
							var _v3 = recordAccesses.a;
							var firstRecordAccessRange = _v3.a;
							var referenceNode = A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{
									w: {p: firstRecordAccessRange.z.p - 1, t: firstRecordAccessRange.z.t},
									z: range.z
								},
								A2(
									$stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue,
									A2($elm$core$List$cons, firstName, qualificationAfter),
									unqualified));
							return A3(
								$elm$core$List$foldl,
								F2(
									function (fieldNode, leftNode) {
										var fieldRange = fieldNode.a;
										var leftRange = leftNode.a;
										return A2(
											$stil4m$elm_syntax$Elm$Syntax$Node$Node,
											{w: fieldRange.w, z: leftRange.z},
											A2($stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess, leftNode, fieldNode));
									}),
								referenceNode,
								recordAccesses);
						}
					}
				}()
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
	$stil4m$elm_syntax$Elm$Parser$Expression$maybeDotReferenceExpressionTuple);
var $stil4m$elm_syntax$Elm$Parser$Expression$unqualifiedFunctionReferenceExpressionFollowedByRecordAccess = A3(
	$stil4m$elm_syntax$ParserFast$map2,
	F2(
		function (leftestResult, recordAccesses) {
			if (!recordAccesses.b) {
				return leftestResult;
			} else {
				return {
					ao: leftestResult.ao,
					a: A3(
						$elm$core$List$foldl,
						F2(
							function (fieldNode, leftNode) {
								var fieldRange = fieldNode.a;
								var leftRange = leftNode.a;
								return A2(
									$stil4m$elm_syntax$Elm$Syntax$Node$Node,
									{w: fieldRange.w, z: leftRange.z},
									A2($stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess, leftNode, fieldNode));
							}),
						leftestResult.a,
						recordAccesses)
				};
			}
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange(
		F2(
			function (range, unqualified) {
				return {
					ao: $stil4m$elm_syntax$Rope$empty,
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						A2($stil4m$elm_syntax$Elm$Syntax$Expression$FunctionOrValue, _List_Nil, unqualified))
				};
			})),
	$stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccess);
var $stil4m$elm_syntax$Elm$Parser$Expression$referenceOrNumberExpression = A3($stil4m$elm_syntax$ParserFast$oneOf3, $stil4m$elm_syntax$Elm$Parser$Expression$qualifiedOrVariantOrRecordConstructorReferenceExpressionFollowedByRecordAccess, $stil4m$elm_syntax$Elm$Parser$Expression$unqualifiedFunctionReferenceExpressionFollowedByRecordAccess, $stil4m$elm_syntax$Elm$Parser$Expression$numberExpression);
var $stil4m$elm_syntax$ParserFast$symbolBacktrackableFollowedBy = F2(
	function (str, _v0) {
		var parseNext = _v0;
		var strLength = $elm$core$String$length(str);
		return function (s) {
			var newOffset = s.c + strLength;
			return _Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				str + '') ? parseNext(
				{S: s.S + strLength, g: s.g, c: newOffset, t: s.t, b: s.b}) : A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s.t, s.S, str));
		};
	});
var $stil4m$elm_syntax$ParserFast$symbolWithEndLocation = F2(
	function (str, endLocationToRes) {
		var strLength = $elm$core$String$length(str);
		return function (s) {
			var newOffset = s.c + strLength;
			if (_Utils_eq(
				A3($elm$core$String$slice, s.c, newOffset, s.b),
				str + '')) {
				var newCol = s.S + strLength;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					endLocationToRes(
						{p: newCol, t: s.t}),
					{S: newCol, g: s.g, c: newOffset, t: s.t, b: s.b});
			} else {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A3($stil4m$elm_syntax$ParserFast$ExpectingSymbol, s.t, s.S, str));
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$temporaryErrPrecedenceTooHigh = $elm$core$Result$Err('infix operator precedence too high');
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$FieldsAfterName = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$RecordExtensionExpressionAfterName = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$genericTypeAnnotation = $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange(
	F2(
		function (range, _var) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericType(_var))
			};
		}));
var $stil4m$elm_syntax$ParserFast$map3WithRange = F4(
	function (func, _v0, _v1, _v2) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		return function (s0) {
			var _v3 = parseA(s0);
			if (_v3.$ === 1) {
				var committed = _v3.a;
				var x = _v3.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v3.a;
				var s1 = _v3.b;
				var _v4 = parseB(s1);
				if (_v4.$ === 1) {
					var x = _v4.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v4.a;
					var s2 = _v4.b;
					var _v5 = parseC(s2);
					if (_v5.$ === 1) {
						var x = _v5.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v5.a;
						var s3 = _v5.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A4(
								func,
								{
									w: {p: s3.S, t: s3.t},
									z: {p: s0.S, t: s0.t}
								},
								a,
								b,
								c),
							s3);
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$map6WithRange = F7(
	function (func, _v0, _v1, _v2, _v3, _v4, _v5) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		var parseF = _v5;
		return function (s0) {
			var _v6 = parseA(s0);
			if (_v6.$ === 1) {
				var committed = _v6.a;
				var x = _v6.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v6.a;
				var s1 = _v6.b;
				var _v7 = parseB(s1);
				if (_v7.$ === 1) {
					var x = _v7.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v7.a;
					var s2 = _v7.b;
					var _v8 = parseC(s2);
					if (_v8.$ === 1) {
						var x = _v8.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v8.a;
						var s3 = _v8.b;
						var _v9 = parseD(s3);
						if (_v9.$ === 1) {
							var x = _v9.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v9.a;
							var s4 = _v9.b;
							var _v10 = parseE(s4);
							if (_v10.$ === 1) {
								var x = _v10.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v10.a;
								var s5 = _v10.b;
								var _v11 = parseF(s5);
								if (_v11.$ === 1) {
									var x = _v11.b;
									return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
								} else {
									var f = _v11.a;
									var s6 = _v11.b;
									return A2(
										$stil4m$elm_syntax$ParserFast$Good,
										A7(
											func,
											{
												w: {p: s6.S, t: s6.t},
												z: {p: s0.S, t: s0.t}
											},
											a,
											b,
											c,
											d,
											e,
											f),
										s6);
								}
							}
						}
					}
				}
			}
		};
	});
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$maybeDotTypeNamesTuple() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map2OrSucceed,
		F2(
			function (firstName, afterFirstName) {
				if (afterFirstName.$ === 1) {
					return $elm$core$Maybe$Just(
						_Utils_Tuple2(_List_Nil, firstName));
				} else {
					var _v1 = afterFirstName.a;
					var qualificationAfter = _v1.a;
					var unqualified = _v1.b;
					return $elm$core$Maybe$Just(
						_Utils_Tuple2(
							A2($elm$core$List$cons, firstName, qualificationAfter),
							unqualified));
				}
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '.', $stil4m$elm_syntax$Elm$Parser$Tokens$typeName),
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v2) {
				return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$maybeDotTypeNamesTuple();
			}),
		$elm$core$Maybe$Nothing);
}
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$maybeDotTypeNamesTuple = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$maybeDotTypeNamesTuple();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$maybeDotTypeNamesTuple = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$maybeDotTypeNamesTuple;
};
var $stil4m$elm_syntax$ParserFast$oneOf4 = F4(
	function (_v0, _v1, _v2, _v3) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		var attemptThird = _v2;
		var attemptFourth = _v3;
		return function (s) {
			var _v4 = attemptFirst(s);
			if (!_v4.$) {
				var firstGood = _v4;
				return firstGood;
			} else {
				var firstBad = _v4;
				var firstCommitted = firstBad.a;
				var firstX = firstBad.b;
				if (firstCommitted) {
					return firstBad;
				} else {
					var _v5 = attemptSecond(s);
					if (!_v5.$) {
						var secondGood = _v5;
						return secondGood;
					} else {
						var secondBad = _v5;
						var secondCommitted = secondBad.a;
						var secondX = secondBad.b;
						if (secondCommitted) {
							return secondBad;
						} else {
							var _v6 = attemptThird(s);
							if (!_v6.$) {
								var thirdGood = _v6;
								return thirdGood;
							} else {
								var thirdBad = _v6;
								var thirdCommitted = thirdBad.a;
								var thirdX = thirdBad.b;
								if (thirdCommitted) {
									return thirdBad;
								} else {
									var _v7 = attemptFourth(s);
									if (!_v7.$) {
										var fourthGood = _v7;
										return fourthGood;
									} else {
										var fourthBad = _v7;
										var fourthCommitted = fourthBad.a;
										var fourthX = fourthBad.b;
										return fourthCommitted ? fourthBad : A2(
											$stil4m$elm_syntax$ParserFast$Bad,
											false,
											A3(
												$stil4m$elm_syntax$ParserFast$ExpectingOneOf,
												firstX,
												secondX,
												_List_fromArray(
													[thirdX, fourthX])));
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationRecordEmpty = $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record(_List_Nil);
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typedTypeAnnotationWithoutArguments = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, startName, afterStartName) {
			var name = function () {
				if (afterStartName.$ === 1) {
					return _Utils_Tuple2(_List_Nil, startName);
				} else {
					var _v1 = afterStartName.a;
					var qualificationAfterStartName = _v1.a;
					var unqualified = _v1.b;
					return _Utils_Tuple2(
						A2($elm$core$List$cons, startName, qualificationAfterStartName),
						unqualified);
				}
			}();
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					A2(
						$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
						A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, name),
						_List_Nil))
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
	$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$maybeDotTypeNamesTuple);
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnIncludingTypedWithArguments() {
	return A4(
		$stil4m$elm_syntax$ParserFast$oneOf4,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$parensTypeAnnotation(),
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typedTypeAnnotationWithArgumentsOptimisticLayout(),
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$genericTypeAnnotation,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordTypeAnnotation());
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typedTypeAnnotationWithArgumentsOptimisticLayout() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (nameNode, commentsAfterName, argsReverse) {
				var nameRange = nameNode.a;
				var range = function () {
					var _v8 = argsReverse.a;
					if (!_v8.b) {
						return nameRange;
					} else {
						var _v9 = _v8.a;
						var lastArgRange = _v9.a;
						return {w: lastArgRange.w, z: nameRange.z};
					}
				}();
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, argsReverse.ao, commentsAfterName),
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						A2(
							$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Typed,
							nameNode,
							$elm$core$List$reverse(argsReverse.a)))
				};
			}),
		A3(
			$stil4m$elm_syntax$ParserFast$map2WithRange,
			F3(
				function (range, startName, afterStartName) {
					var name = function () {
						if (afterStartName.$ === 1) {
							return _Utils_Tuple2(_List_Nil, startName);
						} else {
							var _v11 = afterStartName.a;
							var qualificationAfterStartName = _v11.a;
							var unqualified = _v11.b;
							return _Utils_Tuple2(
								A2($elm$core$List$cons, startName, qualificationAfterStartName),
								unqualified);
						}
					}();
					return A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, name);
				}),
			$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
			$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$maybeDotTypeNamesTuple),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
			$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy(
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (typeAnnotationResult, commentsAfter) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, typeAnnotationResult.ao),
								a: typeAnnotationResult.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnExcludingTypedWithArguments(),
					$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout))));
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnExcludingTypedWithArguments() {
	return A4(
		$stil4m$elm_syntax$ParserFast$oneOf4,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$parensTypeAnnotation(),
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typedTypeAnnotationWithoutArguments,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$genericTypeAnnotation,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordTypeAnnotation());
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$parensTypeAnnotation() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'(',
		A2(
			$stil4m$elm_syntax$ParserFast$oneOf2,
			A2(
				$stil4m$elm_syntax$ParserFast$symbolWithEndLocation,
				')',
				function (end) {
					return {
						ao: $stil4m$elm_syntax$Rope$empty,
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: end,
								z: {p: end.p - 2, t: end.t}
							},
							$stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Unit)
					};
				}),
			A5(
				$stil4m$elm_syntax$ParserFast$map4WithRange,
				F5(
					function (rangeAfterOpeningParens, commentsBeforeFirstPart, firstPart, commentsAfterFirstPart, lastToSecondPart) {
						return {
							ao: A2(
								$stil4m$elm_syntax$Rope$prependTo,
								lastToSecondPart.ao,
								A2(
									$stil4m$elm_syntax$Rope$prependTo,
									commentsAfterFirstPart,
									A2($stil4m$elm_syntax$Rope$prependTo, firstPart.ao, commentsBeforeFirstPart))),
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{
									w: rangeAfterOpeningParens.w,
									z: {p: rangeAfterOpeningParens.z.p - 1, t: rangeAfterOpeningParens.z.t}
								},
								function () {
									var _v5 = lastToSecondPart.a;
									if (_v5.$ === 1) {
										var _v6 = firstPart.a;
										var firstPartType = _v6.b;
										return firstPartType;
									} else {
										var firstAndMaybeThirdPart = _v5.a;
										var _v7 = firstAndMaybeThirdPart.ab;
										if (_v7.$ === 1) {
											return $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled(
												_List_fromArray(
													[firstPart.a, firstAndMaybeThirdPart.O]));
										} else {
											var thirdPart = _v7.a;
											return $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Tupled(
												_List_fromArray(
													[firstPart.a, firstAndMaybeThirdPart.O, thirdPart]));
										}
									}
								}())
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation(),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				A2(
					$stil4m$elm_syntax$ParserFast$oneOf2,
					A2(
						$stil4m$elm_syntax$ParserFast$symbol,
						')',
						{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}),
					A2(
						$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
						',',
						A5(
							$stil4m$elm_syntax$ParserFast$map4,
							F4(
								function (commentsBefore, secondPartResult, commentsAfter, maybeThirdPartResult) {
									return {
										ao: A2(
											$stil4m$elm_syntax$Rope$prependTo,
											commentsAfter,
											A2($stil4m$elm_syntax$Rope$prependTo, secondPartResult.ao, commentsBefore)),
										a: $elm$core$Maybe$Just(
											{ab: maybeThirdPartResult.a, O: secondPartResult.a})
									};
								}),
							$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
							$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation(),
							$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
							A2(
								$stil4m$elm_syntax$ParserFast$oneOf2,
								A2(
									$stil4m$elm_syntax$ParserFast$symbol,
									')',
									{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}),
								A2(
									$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
									',',
									A2(
										$stil4m$elm_syntax$ParserFast$followedBySymbol,
										')',
										A4(
											$stil4m$elm_syntax$ParserFast$map3,
											F3(
												function (commentsBefore, thirdPartResult, commentsAfter) {
													return {
														ao: A2(
															$stil4m$elm_syntax$Rope$prependTo,
															commentsAfter,
															A2($stil4m$elm_syntax$Rope$prependTo, thirdPartResult.ao, commentsBefore)),
														a: $elm$core$Maybe$Just(thirdPartResult.a)
													};
												}),
											$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
											$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation(),
											$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))))))))));
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordTypeAnnotation() {
	return A3(
		$stil4m$elm_syntax$ParserFast$map2WithRange,
		F3(
			function (range, commentsBefore, afterCurly) {
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, afterCurly.ao, commentsBefore),
					a: function () {
						var _v3 = afterCurly.a;
						if (_v3.$ === 1) {
							return A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationRecordEmpty);
						} else {
							var afterCurlyResult = _v3.a;
							return A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, afterCurlyResult);
						}
					}()
				};
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '{', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		A2(
			$stil4m$elm_syntax$ParserFast$oneOf2,
			A2(
				$stil4m$elm_syntax$ParserFast$followedBySymbol,
				'}',
				A4(
					$stil4m$elm_syntax$ParserFast$map3,
					F3(
						function (firstNameNode, commentsAfterFirstName, afterFirstName) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, afterFirstName.ao, commentsAfterFirstName),
								a: $elm$core$Maybe$Just(
									function () {
										var _v4 = afterFirstName.a;
										if (!_v4.$) {
											var fields = _v4.a;
											return A2($stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$GenericRecord, firstNameNode, fields);
										} else {
											var fieldsAfterName = _v4.a;
											return $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$Record(
												A2(
													$elm$core$List$cons,
													A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $elm$core$Tuple$pair, firstNameNode, fieldsAfterName.V),
													fieldsAfterName.ai));
										}
									}())
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					A2(
						$stil4m$elm_syntax$ParserFast$oneOf2,
						A2(
							$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
							'|',
							A4(
								$stil4m$elm_syntax$ParserFast$map3WithRange,
								F4(
									function (range, commentsBefore, head, tail) {
										return {
											ao: A2(
												$stil4m$elm_syntax$Rope$prependTo,
												tail.ao,
												A2($stil4m$elm_syntax$Rope$prependTo, head.ao, commentsBefore)),
											a: $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$RecordExtensionExpressionAfterName(
												A2(
													$stil4m$elm_syntax$Elm$Syntax$Node$Node,
													range,
													A2($elm$core$List$cons, head.a, tail.a)))
										};
									}),
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
								$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition(),
								$stil4m$elm_syntax$ParserWithComments$many(
									A2(
										$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
										',',
										A3(
											$stil4m$elm_syntax$ParserFast$map2,
											F2(
												function (commentsBefore, field) {
													return {
														ao: A2($stil4m$elm_syntax$Rope$prependTo, field.ao, commentsBefore),
														a: field.a
													};
												}),
											$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
											$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition()))))),
						A2(
							$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
							':',
							A5(
								$stil4m$elm_syntax$ParserFast$map4,
								F4(
									function (commentsBeforeFirstFieldValue, firstFieldValue, commentsAfterFirstFieldValue, tailFields) {
										return {
											ao: A2(
												$stil4m$elm_syntax$Rope$prependTo,
												tailFields.ao,
												A2(
													$stil4m$elm_syntax$Rope$prependTo,
													commentsAfterFirstFieldValue,
													A2($stil4m$elm_syntax$Rope$prependTo, firstFieldValue.ao, commentsBeforeFirstFieldValue))),
											a: $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$FieldsAfterName(
												{V: firstFieldValue.a, ai: tailFields.a})
										};
									}),
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
								$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation(),
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
								A2(
									$stil4m$elm_syntax$ParserFast$orSucceed,
									A2(
										$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
										',',
										$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldsTypeAnnotation()),
									{ao: $stil4m$elm_syntax$Rope$empty, a: _List_Nil})))))),
			A2(
				$stil4m$elm_syntax$ParserFast$symbol,
				'}',
				{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing})));
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldsTypeAnnotation() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (commentsBefore, head, tail) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						tail.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, head.ao, commentsBefore)),
					a: A2($elm$core$List$cons, head.a, tail.a)
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition(),
		$stil4m$elm_syntax$ParserWithComments$many(
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				',',
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (commentsBefore, field) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, field.ao, commentsBefore),
								a: field.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition()))));
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition() {
	return A7(
		$stil4m$elm_syntax$ParserFast$map6WithRange,
		F7(
			function (range, commentsBeforeFunctionName, name, commentsAfterFunctionName, commentsAfterColon, value, commentsAfterValue) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterValue,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							value.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterColon,
								A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterFunctionName, commentsBeforeFunctionName)))),
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						_Utils_Tuple2(name, value.a))
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation(),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout);
}
function $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (inType, commentsAfterIn, maybeOut) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						maybeOut.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterIn, inType.ao)),
					a: function () {
						var _v0 = maybeOut.a;
						if (_v0.$ === 1) {
							return inType.a;
						} else {
							var out = _v0.a;
							return A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$TypeAnnotation$FunctionTypeAnnotation, inType.a, out);
						}
					}()
				};
			}),
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v1) {
				return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnIncludingTypedWithArguments();
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		A4(
			$stil4m$elm_syntax$ParserFast$map2OrSucceed,
			F2(
				function (commentsAfterArrow, typeAnnotationResult) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, typeAnnotationResult.ao, commentsAfterArrow),
						a: $elm$core$Maybe$Just(typeAnnotationResult.a)
					};
				}),
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				'->',
				A2($stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedPlusFollowedBy, 2, $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)),
			$stil4m$elm_syntax$ParserFast$lazy(
				function (_v2) {
					return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation();
				}),
			{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}));
}
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationNoFnIncludingTypedWithArguments = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnIncludingTypedWithArguments();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnIncludingTypedWithArguments = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationNoFnIncludingTypedWithArguments;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typedTypeAnnotationWithArgumentsOptimisticLayout = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typedTypeAnnotationWithArgumentsOptimisticLayout();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typedTypeAnnotationWithArgumentsOptimisticLayout = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typedTypeAnnotationWithArgumentsOptimisticLayout;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationNoFnExcludingTypedWithArguments = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnExcludingTypedWithArguments();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotationNoFnExcludingTypedWithArguments = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationNoFnExcludingTypedWithArguments;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$parensTypeAnnotation = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$parensTypeAnnotation();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$parensTypeAnnotation = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$parensTypeAnnotation;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordTypeAnnotation = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordTypeAnnotation();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordTypeAnnotation = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordTypeAnnotation;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordFieldsTypeAnnotation = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldsTypeAnnotation();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldsTypeAnnotation = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordFieldsTypeAnnotation;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordFieldDefinition = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$recordFieldDefinition = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$recordFieldDefinition;
};
var $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation = $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation();
$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$cyclic$typeAnnotation = function () {
	return $stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation;
};
var $stil4m$elm_syntax$ParserFast$validate = F3(
	function (isOkay, problemOnNotOkay, _v0) {
		var parseA = _v0;
		return function (s0) {
			var _v1 = parseA(s0);
			if (_v1.$ === 1) {
				var committed = _v1.a;
				var x = _v1.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var good = _v1;
				var a = good.a;
				var s1 = good.b;
				return isOkay(a) ? good : A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					true,
					A3($stil4m$elm_syntax$ParserFast$ExpectingCustom, s1.t, s1.S, problemOnNotOkay));
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$whileWithoutLinebreakAnd2PartUtf16ToResultAndThen = F3(
	function (whileCharIsOkay, consumedStringToIntermediateOrErr, intermediateToFollowupParser) {
		return function (s0) {
			var s1Offset = A3($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakAnd2PartUtf16Help, whileCharIsOkay, s0.c, s0.b);
			var whileContent = A3($elm$core$String$slice, s0.c, s1Offset, s0.b);
			var _v0 = consumedStringToIntermediateOrErr(whileContent);
			if (_v0.$ === 1) {
				var problemMessage = _v0.a;
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A3($stil4m$elm_syntax$ParserFast$ExpectingCustom, s0.t, s0.S, problemMessage));
			} else {
				var intermediate = _v0.a;
				var s1Column = s0.S + (s1Offset - s0.c);
				var _v1 = intermediateToFollowupParser(intermediate);
				var parseFollowup = _v1;
				return $stil4m$elm_syntax$ParserFast$pStepCommit(
					parseFollowup(
						{S: s1Column, g: s0.g, c: s1Offset, t: s0.t, b: s0.b}));
			}
		};
	});
var $stil4m$elm_syntax$ParserFast$changeIndent = F2(
	function (newIndent, s) {
		return {S: s.S, g: newIndent, c: s.c, t: s.t, b: s.b};
	});
var $stil4m$elm_syntax$ParserFast$withIndentSetToColumn = function (_v0) {
	var parse = _v0;
	return function (s0) {
		var _v1 = parse(
			A2($stil4m$elm_syntax$ParserFast$changeIndent, s0.S, s0));
		if (!_v1.$) {
			var a = _v1.a;
			var s1 = _v1.b;
			return A2(
				$stil4m$elm_syntax$ParserFast$Good,
				a,
				A2($stil4m$elm_syntax$ParserFast$changeIndent, s0.g, s1));
		} else {
			var bad = _v1;
			return bad;
		}
	};
};
var $stil4m$elm_syntax$ParserFast$withIndentSetToColumnMinus = F2(
	function (columnToMoveIndentationBaseBackBy, _v0) {
		var parse = _v0;
		return function (s0) {
			var _v1 = parse(
				A2($stil4m$elm_syntax$ParserFast$changeIndent, s0.S - columnToMoveIndentationBaseBackBy, s0));
			if (!_v1.$) {
				var a = _v1.a;
				var s1 = _v1.b;
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					a,
					A2($stil4m$elm_syntax$ParserFast$changeIndent, s0.g, s1));
			} else {
				var bad = _v1;
				return bad;
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$extendedSubExpressionOptimisticLayout = F2(
	function (toResult, afterCommitting) {
		return A4(
			$stil4m$elm_syntax$ParserFast$loopWhileSucceedsOntoResultFromParser,
			$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy(
				A2($stil4m$elm_syntax$Elm$Parser$Expression$infixOperatorAndThen, toResult, afterCommitting)),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpressionMaybeAppliedOptimisticLayout(),
			F2(
				function (extensionRightResult, leftNodeWithComments) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, extensionRightResult.ao, leftNodeWithComments.ao),
						a: A2($stil4m$elm_syntax$Elm$Parser$Expression$applyExtensionRight, extensionRightResult.a, leftNodeWithComments.a)
					};
				}),
			$elm$core$Basics$identity);
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$infixLeft = F2(
	function (leftPrecedence, symbol) {
		return {
			q: A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsBeforeFirst, first) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, first.ao, commentsBeforeFirst),
							a: {e: 0, E: first.a, u: symbol}
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				A2(
					$stil4m$elm_syntax$Elm$Parser$Expression$extendedSubExpressionOptimisticLayout,
					function (info) {
						return (_Utils_cmp(info.r, leftPrecedence) > 0) ? $elm$core$Result$Ok(info) : $stil4m$elm_syntax$Elm$Parser$Expression$temporaryErrPrecedenceTooHigh;
					},
					function ($) {
						return $.q;
					})),
			r: leftPrecedence,
			u: symbol
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative = F2(
	function (leftPrecedence, symbol) {
		return {
			q: A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsBefore, right) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, right.ao, commentsBefore),
							a: {e: 2, E: right.a, u: symbol}
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				A2(
					$stil4m$elm_syntax$Elm$Parser$Expression$extendedSubExpressionOptimisticLayout,
					function (info) {
						return (_Utils_cmp(info.r, leftPrecedence) > -1) ? $elm$core$Result$Ok(info) : $stil4m$elm_syntax$Elm$Parser$Expression$temporaryErrPrecedenceTooHigh;
					},
					function (info) {
						return _Utils_eq(info.r, leftPrecedence) ? $stil4m$elm_syntax$Elm$Parser$Expression$problemCannotMixNonAssociativeInfixOperators : info.q;
					})),
			r: leftPrecedence,
			u: symbol
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$infixOperatorAndThen = F2(
	function (toResult, afterCommitting) {
		return A3(
			$stil4m$elm_syntax$ParserFast$whileWithoutLinebreakAnd2PartUtf16ToResultAndThen,
			$stil4m$elm_syntax$Elm$Parser$Tokens$isOperatorSymbolChar,
			function (operator) {
				switch (operator) {
					case '|>':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApR());
					case '++':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5append());
					case '<|':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApL());
					case '>>':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeR());
					case '==':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Eq());
					case '*':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Mul());
					case '::':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Cons());
					case '+':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Add());
					case '-':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Sub());
					case '|.':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Ignore());
					case '&&':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence3And());
					case '|=':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Keep());
					case '<<':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeL());
					case '/=':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Neq());
					case '//':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Idiv());
					case '/':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Fdiv());
					case '</>':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Slash());
					case '||':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence2Or());
					case '<=':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Le());
					case '>=':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Ge());
					case '>':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Gt());
					case '<?>':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8QuestionMark());
					case '<':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Lt());
					case '^':
						return toResult(
							$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8Pow());
					default:
						return $stil4m$elm_syntax$Elm$Parser$Expression$errUnknownInfixOperator;
				}
			},
			afterCommitting);
	});
var $stil4m$elm_syntax$Elm$Parser$Expression$infixRight = F2(
	function (leftPrecedence, symbol) {
		return {
			q: A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsBeforeFirst, first) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, first.ao, commentsBeforeFirst),
							a: {e: 1, E: first.a, u: symbol}
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				A2(
					$stil4m$elm_syntax$Elm$Parser$Expression$extendedSubExpressionOptimisticLayout,
					function (info) {
						return (_Utils_cmp(info.r, leftPrecedence) > -1) ? $elm$core$Result$Ok(info) : $stil4m$elm_syntax$Elm$Parser$Expression$temporaryErrPrecedenceTooHigh;
					},
					function ($) {
						return $.q;
					})),
			r: leftPrecedence,
			u: symbol
		};
	});
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letOrUnqualifiedReferenceExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letExpression(),
		$stil4m$elm_syntax$Elm$Parser$Expression$unqualifiedFunctionReferenceExpressionFollowedByRecordAccess);
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$keywordFollowedBy,
		'let',
		A4(
			$stil4m$elm_syntax$ParserFast$map3WithStartLocation,
			F4(
				function (start, declarations, commentsAfterIn, expressionResult) {
					var _v38 = expressionResult.a;
					var expressionRange = _v38.a;
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							expressionResult.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterIn, declarations.ao)),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: expressionRange.w,
								z: {p: start.p - 3, t: start.t}
							},
							$stil4m$elm_syntax$Elm$Syntax$Expression$LetExpression(
								{T: declarations.T, E: expressionResult.a}))
					};
				}),
			A2(
				$stil4m$elm_syntax$ParserFast$withIndentSetToColumnMinus,
				3,
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (commentsAfterLet, declarations) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, declarations.ao, commentsAfterLet),
								T: declarations.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$ParserFast$withIndentSetToColumn(
						$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDeclarationsIn()))),
			A2($stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedPlusFollowedBy, 2, $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDeclarationsIn() {
	return $stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(
		A4(
			$stil4m$elm_syntax$ParserFast$map3,
			F3(
				function (headLetResult, commentsAfter, tailLetResult) {
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							tailLetResult.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, headLetResult.ao)),
						a: A2($elm$core$List$cons, headLetResult.a, tailLetResult.a)
					};
				}),
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letFunction(),
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDestructuringDeclaration()),
			$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
			A2(
				$stil4m$elm_syntax$ParserWithComments$until,
				$stil4m$elm_syntax$Elm$Parser$Tokens$inToken,
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$blockElement())));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$blockElement() {
	return $stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(
		A3(
			$stil4m$elm_syntax$ParserFast$map2,
			F2(
				function (letDeclarationResult, commentsAfter) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, letDeclarationResult.ao),
						a: letDeclarationResult.a
					};
				}),
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letFunction(),
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDestructuringDeclaration()),
			$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseOrUnqualifiedReferenceExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseExpression(),
		$stil4m$elm_syntax$Elm$Parser$Expression$unqualifiedFunctionReferenceExpressionFollowedByRecordAccess);
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$keywordFollowedBy,
		'case',
		A6(
			$stil4m$elm_syntax$ParserFast$map5WithStartLocation,
			F6(
				function (start, commentsAfterCase, casedExpressionResult, commentsBeforeOf, commentsAfterOf, casesResult) {
					var _v32 = casesResult.a;
					var firstCase = _v32.a;
					var lastToSecondCase = _v32.b;
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							casesResult.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterOf,
								A2(
									$stil4m$elm_syntax$Rope$prependTo,
									commentsBeforeOf,
									A2($stil4m$elm_syntax$Rope$prependTo, casedExpressionResult.ao, commentsAfterCase)))),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: function () {
									if (lastToSecondCase.b) {
										var _v34 = lastToSecondCase.a;
										var _v35 = _v34.b;
										var lastCaseExpressionRange = _v35.a;
										return lastCaseExpressionRange.w;
									} else {
										var _v36 = firstCase;
										var _v37 = _v36.b;
										var firstCaseExpressionRange = _v37.a;
										return firstCaseExpressionRange.w;
									}
								}(),
								z: {p: start.p - 4, t: start.t}
							},
							$stil4m$elm_syntax$Elm$Syntax$Expression$CaseExpression(
								{
									am: A2(
										$elm$core$List$cons,
										firstCase,
										$elm$core$List$reverse(lastToSecondCase)),
									E: casedExpressionResult.a
								}))
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'of', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$ParserFast$withIndentSetToColumn(
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatements())));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatements() {
	return A6(
		$stil4m$elm_syntax$ParserFast$map5,
		F5(
			function (firstCasePatternResult, commentsAfterFirstCasePattern, commentsAfterFirstCaseArrowRight, firstCaseExpressionResult, lastToSecondCase) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						lastToSecondCase.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							firstCaseExpressionResult.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterFirstCaseArrowRight,
								A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterFirstCasePattern, firstCasePatternResult.ao)))),
					a: _Utils_Tuple2(
						_Utils_Tuple2(firstCasePatternResult.a, firstCaseExpressionResult.a),
						lastToSecondCase.a)
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$pattern,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '->', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
		$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatement()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatement() {
	return $stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(
		A5(
			$stil4m$elm_syntax$ParserFast$map4,
			F4(
				function (pattern, commentsBeforeArrowRight, commentsAfterArrowRight, expr) {
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							expr.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterArrowRight,
								A2($stil4m$elm_syntax$Rope$prependTo, commentsBeforeArrowRight, pattern.ao))),
						a: _Utils_Tuple2(pattern.a, expr.a)
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Patterns$pattern,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '->', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionIfNecessaryFollowedByRecordAccess() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'(',
		A3(
			$stil4m$elm_syntax$ParserFast$oneOf3,
			A2(
				$stil4m$elm_syntax$ParserFast$symbolWithEndLocation,
				')',
				function (end) {
					return {
						ao: $stil4m$elm_syntax$Rope$empty,
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: end,
								z: {p: end.p - 2, t: end.t}
							},
							$stil4m$elm_syntax$Elm$Syntax$Expression$UnitExpr)
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Expression$allowedPrefixOperatorFollowedByClosingParensOneOf,
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionInnerAfterOpeningParens()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionInnerAfterOpeningParens() {
	return A5(
		$stil4m$elm_syntax$ParserFast$map4WithRange,
		F5(
			function (rangeAfterOpeningParens, commentsBeforeFirstPart, firstPart, commentsAfterFirstPart, tailParts) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						tailParts.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsAfterFirstPart,
							A2($stil4m$elm_syntax$Rope$prependTo, firstPart.ao, commentsBeforeFirstPart))),
					a: function () {
						var _v27 = tailParts.a;
						if (!_v27.$) {
							var recordAccesses = _v27.a;
							if (!recordAccesses.b) {
								return A2(
									$stil4m$elm_syntax$Elm$Syntax$Node$Node,
									{
										w: rangeAfterOpeningParens.w,
										z: {p: rangeAfterOpeningParens.z.p - 1, t: rangeAfterOpeningParens.z.t}
									},
									$stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(firstPart.a));
							} else {
								var _v29 = recordAccesses.a;
								var firstRecordAccessRange = _v29.a;
								var range = {
									w: {p: firstRecordAccessRange.z.p - 1, t: firstRecordAccessRange.z.t},
									z: {p: rangeAfterOpeningParens.z.p - 1, t: rangeAfterOpeningParens.z.t}
								};
								var parenthesizedNode = A2(
									$stil4m$elm_syntax$Elm$Syntax$Node$Node,
									range,
									$stil4m$elm_syntax$Elm$Syntax$Expression$ParenthesizedExpression(firstPart.a));
								return A3(
									$elm$core$List$foldl,
									F2(
										function (fieldNode, leftNode) {
											var fieldRange = fieldNode.a;
											var leftRange = leftNode.a;
											return A2(
												$stil4m$elm_syntax$Elm$Syntax$Node$Node,
												{w: fieldRange.w, z: leftRange.z},
												A2($stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess, leftNode, fieldNode));
										}),
									parenthesizedNode,
									recordAccesses);
							}
						} else {
							var _v30 = _v27.a;
							var secondPart = _v30.a;
							var maybeThirdPart = _v30.b;
							return A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{
									w: rangeAfterOpeningParens.w,
									z: {p: rangeAfterOpeningParens.z.p - 1, t: rangeAfterOpeningParens.z.t}
								},
								function () {
									if (maybeThirdPart.$ === 1) {
										return $stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression(
											_List_fromArray(
												[firstPart.a, secondPart]));
									} else {
										var thirdPart = maybeThirdPart.a;
										return $stil4m$elm_syntax$Elm$Syntax$Expression$TupledExpression(
											_List_fromArray(
												[firstPart.a, secondPart, thirdPart]));
									}
								}());
						}
					}()
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A2(
			$stil4m$elm_syntax$ParserFast$oneOf2,
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				')',
				$stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccessMap(
					function (recordAccesses) {
						return {
							ao: $stil4m$elm_syntax$Rope$empty,
							a: $stil4m$elm_syntax$Elm$Parser$Expression$TupledParenthesizedFollowedByRecordAccesses(recordAccesses)
						};
					})),
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				',',
				A5(
					$stil4m$elm_syntax$ParserFast$map4,
					F4(
						function (commentsBefore, partResult, commentsAfter, maybeThirdPart) {
							return {
								ao: A2(
									$stil4m$elm_syntax$Rope$prependTo,
									maybeThirdPart.ao,
									A2(
										$stil4m$elm_syntax$Rope$prependTo,
										commentsAfter,
										A2($stil4m$elm_syntax$Rope$prependTo, partResult.ao, commentsBefore))),
								a: $stil4m$elm_syntax$Elm$Parser$Expression$TupledTwoOrThree(
									_Utils_Tuple2(partResult.a, maybeThirdPart.a))
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					A2(
						$stil4m$elm_syntax$ParserFast$oneOf2,
						A2(
							$stil4m$elm_syntax$ParserFast$symbol,
							')',
							{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}),
						A2(
							$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
							',',
							A2(
								$stil4m$elm_syntax$ParserFast$followedBySymbol,
								')',
								A4(
									$stil4m$elm_syntax$ParserFast$map3,
									F3(
										function (commentsBefore, partResult, commentsAfter) {
											return {
												ao: A2(
													$stil4m$elm_syntax$Rope$prependTo,
													commentsAfter,
													A2($stil4m$elm_syntax$Rope$prependTo, partResult.ao, commentsBefore)),
												a: $elm$core$Maybe$Just(partResult.a)
											};
										}),
									$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
									$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
									$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))))))));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordExpressionFollowedByRecordAccess() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'{',
		A3(
			$stil4m$elm_syntax$ParserFast$map2,
			F2(
				function (leftestResult, recordAccesses) {
					if (!recordAccesses.b) {
						return leftestResult;
					} else {
						return {
							ao: leftestResult.ao,
							a: A3(
								$elm$core$List$foldl,
								F2(
									function (fieldNode, leftNode) {
										var fieldRange = fieldNode.a;
										var leftRange = leftNode.a;
										return A2(
											$stil4m$elm_syntax$Elm$Syntax$Node$Node,
											{w: fieldRange.w, z: leftRange.z},
											A2($stil4m$elm_syntax$Elm$Syntax$Expression$RecordAccess, leftNode, fieldNode));
									}),
								leftestResult.a,
								recordAccesses)
						};
					}
				}),
			A3(
				$stil4m$elm_syntax$ParserFast$map2WithRange,
				F3(
					function (range, commentsBefore, afterCurly) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, afterCurly.ao, commentsBefore),
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								$stil4m$elm_syntax$Elm$Parser$Expression$rangeMoveStartLeftByOneColumn(range),
								afterCurly.a)
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordContentsCurlyEnd()),
			$stil4m$elm_syntax$Elm$Parser$Expression$multiRecordAccess));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordContentsCurlyEnd() {
	return A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		A6(
			$stil4m$elm_syntax$ParserFast$map5,
			F5(
				function (nameNode, commentsAfterFunctionName, afterNameBeforeFields, tailFields, commentsBeforeClosingCurly) {
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsBeforeClosingCurly,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								tailFields.ao,
								A2($stil4m$elm_syntax$Rope$prependTo, afterNameBeforeFields.ao, commentsAfterFunctionName))),
						a: function () {
							var _v25 = afterNameBeforeFields.a;
							if (!_v25.$) {
								var firstField = _v25.a;
								return A2(
									$stil4m$elm_syntax$Elm$Syntax$Expression$RecordUpdateExpression,
									nameNode,
									A2($elm$core$List$cons, firstField, tailFields.a));
							} else {
								var firstFieldValue = _v25.a;
								return $stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr(
									A2(
										$elm$core$List$cons,
										A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $elm$core$Tuple$pair, nameNode, firstFieldValue),
										tailFields.a));
							}
						}()
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				A2(
					$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
					'|',
					A3(
						$stil4m$elm_syntax$ParserFast$map2,
						F2(
							function (commentsBefore, setterResult) {
								return {
									ao: A2($stil4m$elm_syntax$Rope$prependTo, setterResult.ao, commentsBefore),
									a: $stil4m$elm_syntax$Elm$Parser$Expression$RecordUpdateFirstSetter(setterResult.a)
								};
							}),
						$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
						$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordSetterNodeWithLayout())),
				A2(
					$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
					'=',
					A4(
						$stil4m$elm_syntax$ParserFast$map3,
						F3(
							function (commentsBefore, expressionResult, commentsAfter) {
								return {
									ao: A2(
										$stil4m$elm_syntax$Rope$prependTo,
										commentsAfter,
										A2($stil4m$elm_syntax$Rope$prependTo, expressionResult.ao, commentsBefore)),
									a: $stil4m$elm_syntax$Elm$Parser$Expression$FieldsFirstValue(expressionResult.a)
								};
							}),
						$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
						$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
						$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordFields(),
			A2($stil4m$elm_syntax$ParserFast$followedBySymbol, '}', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)),
		A2(
			$stil4m$elm_syntax$ParserFast$symbol,
			'}',
			{
				ao: $stil4m$elm_syntax$Rope$empty,
				a: $stil4m$elm_syntax$Elm$Syntax$Expression$RecordExpr(_List_Nil)
			}));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordFields() {
	return $stil4m$elm_syntax$ParserWithComments$many(
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			',',
			A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (commentsBefore, setterResult) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, setterResult.ao, commentsBefore),
							a: setterResult.a
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordSetterNodeWithLayout())));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordSetterNodeWithLayout() {
	return A6(
		$stil4m$elm_syntax$ParserFast$map5WithRange,
		F6(
			function (range, name, commentsAfterFunctionName, commentsAfterEquals, expressionResult, commentsAfterExpression) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterExpression,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							expressionResult.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterEquals, commentsAfterFunctionName))),
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						_Utils_Tuple2(name, expressionResult.a))
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '=', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout);
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letFunction() {
	return A3(
		$stil4m$elm_syntax$ParserFast$validate,
		function (result) {
			var _v18 = result.a;
			var letDeclaration = _v18.b;
			if (letDeclaration.$ === 1) {
				return true;
			} else {
				var letFunctionDeclaration = letDeclaration.a;
				var _v20 = letFunctionDeclaration.ay;
				if (_v20.$ === 1) {
					return true;
				} else {
					var _v21 = _v20.a;
					var signature = _v21.b;
					var _v22 = signature.N;
					var signatureName = _v22.b;
					var _v23 = letFunctionDeclaration.ar;
					var implementation = _v23.b;
					var _v24 = implementation.N;
					var implementationName = _v24.b;
					return _Utils_eq(implementationName, signatureName + '');
				}
			}
		},
		'Expected to find the same name for declaration and signature',
		A7(
			$stil4m$elm_syntax$ParserFast$map6WithStartLocation,
			F7(
				function (startNameStart, startNameNode, commentsAfterStartName, maybeSignature, _arguments, commentsAfterEqual, expressionResult) {
					var allComments = A2(
						$stil4m$elm_syntax$Rope$prependTo,
						expressionResult.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsAfterEqual,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								_arguments.ao,
								function () {
									if (maybeSignature.$ === 1) {
										return commentsAfterStartName;
									} else {
										var signature = maybeSignature.a;
										return A2($stil4m$elm_syntax$Rope$prependTo, signature.ao, commentsAfterStartName);
									}
								}())));
					if (maybeSignature.$ === 1) {
						var _v14 = expressionResult.a;
						var expressionRange = _v14.a;
						return {
							ao: allComments,
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: expressionRange.w, z: startNameStart},
								$stil4m$elm_syntax$Elm$Syntax$Expression$LetFunction(
									{
										ar: A2(
											$stil4m$elm_syntax$Elm$Syntax$Node$Node,
											{w: expressionRange.w, z: startNameStart},
											{Q: _arguments.a, E: expressionResult.a, N: startNameNode}),
										K: $elm$core$Maybe$Nothing,
										ay: $elm$core$Maybe$Nothing
									}))
						};
					} else {
						var signature = maybeSignature.a;
						var _v15 = signature.y;
						var implementationNameRange = _v15.a;
						var _v16 = expressionResult.a;
						var expressionRange = _v16.a;
						return {
							ao: allComments,
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: expressionRange.w, z: startNameStart},
								$stil4m$elm_syntax$Elm$Syntax$Expression$LetFunction(
									{
										ar: A2(
											$stil4m$elm_syntax$Elm$Syntax$Node$Node,
											{w: expressionRange.w, z: implementationNameRange.z},
											{Q: _arguments.a, E: expressionResult.a, N: signature.y}),
										K: $elm$core$Maybe$Nothing,
										ay: $elm$core$Maybe$Just(
											A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$Signature$Signature, startNameNode, signature.ak))
									}))
						};
					}
				}),
			$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A6(
				$stil4m$elm_syntax$ParserFast$map4OrSucceed,
				F4(
					function (commentsBeforeTypeAnnotation, typeAnnotationResult, implementationName, afterImplementationName) {
						return $elm$core$Maybe$Just(
							{
								ao: A2(
									$stil4m$elm_syntax$Rope$prependTo,
									afterImplementationName,
									A2(
										$stil4m$elm_syntax$Rope$prependTo,
										implementationName.ao,
										A2($stil4m$elm_syntax$Rope$prependTo, typeAnnotationResult.ao, commentsBeforeTypeAnnotation))),
								y: implementationName.a,
								ak: typeAnnotationResult.a
							});
					}),
				A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
				$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation,
				$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedBy($stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode),
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
				$elm$core$Maybe$Nothing),
			$stil4m$elm_syntax$Elm$Parser$Expression$parameterPatternsEqual,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDestructuringDeclaration() {
	return A5(
		$stil4m$elm_syntax$ParserFast$map4,
		F4(
			function (pattern, commentsAfterPattern, commentsAfterEquals, expressionResult) {
				var _v11 = pattern.a;
				var start = _v11.a.z;
				var _v12 = expressionResult.a;
				var end = _v12.a.w;
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						expressionResult.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsAfterEquals,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterPattern, pattern.ao))),
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						{w: end, z: start},
						A2($stil4m$elm_syntax$Elm$Syntax$Expression$LetDestructuring, pattern.a, expressionResult.a))
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '=', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression());
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$lambdaExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'\\',
		A7(
			$stil4m$elm_syntax$ParserFast$map6WithStartLocation,
			F7(
				function (start, commentsAfterBackslash, firstArg, commentsAfterFirstArg, secondUpArgs, commentsAfterArrow, expressionResult) {
					var _v10 = expressionResult.a;
					var expressionRange = _v10.a;
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							expressionResult.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterArrow,
								A2(
									$stil4m$elm_syntax$Rope$prependTo,
									secondUpArgs.ao,
									A2(
										$stil4m$elm_syntax$Rope$prependTo,
										commentsAfterFirstArg,
										A2($stil4m$elm_syntax$Rope$prependTo, firstArg.ao, commentsAfterBackslash))))),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: expressionRange.w,
								z: {p: start.p - 1, t: start.t}
							},
							$stil4m$elm_syntax$Elm$Syntax$Expression$LambdaExpression(
								{
									al: A2($elm$core$List$cons, firstArg.a, secondUpArgs.a),
									E: expressionResult.a
								}))
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2(
				$stil4m$elm_syntax$ParserWithComments$until,
				A2($stil4m$elm_syntax$ParserFast$symbol, '->', 0),
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (patternResult, commentsAfter) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, patternResult.ao),
								a: patternResult.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing,
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifOrUnqualifiedReferenceExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifBlockExpression(),
		$stil4m$elm_syntax$Elm$Parser$Expression$unqualifiedFunctionReferenceExpressionFollowedByRecordAccess);
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifBlockExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$keywordFollowedBy,
		'if',
		A9(
			$stil4m$elm_syntax$ParserFast$map8WithStartLocation,
			F9(
				function (start, commentsAfterIf, condition, commentsBeforeThen, commentsAfterThen, ifTrue, commentsBeforeElse, commentsAfterElse, ifFalse) {
					var _v9 = ifFalse.a;
					var ifFalseRange = _v9.a;
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							ifFalse.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterElse,
								A2(
									$stil4m$elm_syntax$Rope$prependTo,
									commentsBeforeElse,
									A2(
										$stil4m$elm_syntax$Rope$prependTo,
										ifTrue.ao,
										A2(
											$stil4m$elm_syntax$Rope$prependTo,
											commentsAfterThen,
											A2(
												$stil4m$elm_syntax$Rope$prependTo,
												commentsBeforeThen,
												A2($stil4m$elm_syntax$Rope$prependTo, condition.ao, commentsAfterIf))))))),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: ifFalseRange.w,
								z: {p: start.p - 2, t: start.t}
							},
							A3($stil4m$elm_syntax$Elm$Syntax$Expression$IfBlock, condition.a, ifTrue.a, ifFalse.a))
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'then', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'else', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$listOrGlslExpression() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'[',
		$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expressionAfterOpeningSquareBracket());
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expressionAfterOpeningSquareBracket() {
	return A2(
		$stil4m$elm_syntax$ParserFast$oneOf2,
		$stil4m$elm_syntax$Elm$Parser$Expression$glslExpressionAfterOpeningSquareBracket,
		A3(
			$stil4m$elm_syntax$ParserFast$map2WithRange,
			F3(
				function (range, commentsBefore, elements) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, elements.ao, commentsBefore),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{
								w: range.w,
								z: {p: range.z.p - 1, t: range.z.t}
							},
							elements.a)
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			A2(
				$stil4m$elm_syntax$ParserFast$oneOf2,
				A2(
					$stil4m$elm_syntax$ParserFast$symbol,
					']',
					{
						ao: $stil4m$elm_syntax$Rope$empty,
						a: $stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr(_List_Nil)
					}),
				A2(
					$stil4m$elm_syntax$ParserFast$followedBySymbol,
					']',
					A4(
						$stil4m$elm_syntax$ParserFast$map3,
						F3(
							function (head, commentsAfterHead, tail) {
								return {
									ao: A2(
										$stil4m$elm_syntax$Rope$prependTo,
										tail.ao,
										A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterHead, head.ao)),
									a: $stil4m$elm_syntax$Elm$Syntax$Expression$ListExpr(
										A2($elm$core$List$cons, head.a, tail.a))
								};
							}),
						$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression(),
						$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
						$stil4m$elm_syntax$ParserWithComments$many(
							A2(
								$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
								',',
								$stil4m$elm_syntax$Elm$Parser$Layout$maybeAroundBothSides(
									$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression()))))))));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression() {
	return A2(
		$stil4m$elm_syntax$Elm$Parser$Expression$extendedSubExpressionOptimisticLayout,
		$elm$core$Result$Ok,
		function ($) {
			return $.q;
		});
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeL() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 9, '<<');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8QuestionMark() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 8, '<?>');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Mul() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 7, '*');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Idiv() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 7, '//');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Fdiv() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 7, '/');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Sub() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 6, '-');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Ignore() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 6, '|.');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Add() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 6, '+');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Keep() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 5, '|=');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApR() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixLeft, 1, '|>');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Neq() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '/=');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Lt() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '<');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Le() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '<=');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Gt() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '>');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Ge() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '>=');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Eq() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixNonAssociative, 4, '==');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeR() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 9, '>>');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8Pow() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 8, '^');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Slash() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 7, '</>');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5append() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 5, '++');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Cons() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 5, '::');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence3And() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 3, '&&');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence2Or() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 2, '||');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApL() {
	return A2($stil4m$elm_syntax$Elm$Parser$Expression$infixRight, 1, '<|');
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus() {
	return A2(
		$stil4m$elm_syntax$ParserFast$map,
		function (subExpressionResult) {
			var _v6 = subExpressionResult.a;
			var subExpressionRange = _v6.a;
			return {
				ao: subExpressionResult.ao,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					{
						w: subExpressionRange.w,
						z: {p: subExpressionRange.z.p - 1, t: subExpressionRange.z.t}
					},
					$stil4m$elm_syntax$Elm$Syntax$Expression$Negation(subExpressionResult.a))
			};
		},
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v7) {
				return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression();
			}));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationOperation() {
	return A2(
		$stil4m$elm_syntax$ParserFast$symbolBacktrackableFollowedBy,
		'-',
		$stil4m$elm_syntax$ParserFast$offsetSourceAndThen(
			F2(
				function (offset, source) {
					var _v5 = A3($elm$core$String$slice, offset - 2, offset - 1, source);
					switch (_v5) {
						case ' ':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						case '(':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						case ')':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						case '}':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						case ',':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						case '':
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
						default:
							return $stil4m$elm_syntax$Elm$Parser$Expression$negationWhitespaceProblem;
					}
				})));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression() {
	return $stil4m$elm_syntax$ParserFast$offsetSourceAndThen(
		F2(
			function (offset, source) {
				var _v4 = A3($elm$core$String$slice, offset, offset + 1, source);
				switch (_v4) {
					case '\"':
						return $stil4m$elm_syntax$Elm$Parser$Expression$literalExpression;
					case '(':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionIfNecessaryFollowedByRecordAccess();
					case '[':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$listOrGlslExpression();
					case '{':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordExpressionFollowedByRecordAccess();
					case 'c':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseOrUnqualifiedReferenceExpression();
					case '\\':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$lambdaExpression();
					case 'l':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letOrUnqualifiedReferenceExpression();
					case 'i':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifOrUnqualifiedReferenceExpression();
					case '.':
						return $stil4m$elm_syntax$Elm$Parser$Expression$recordAccessFunctionExpression;
					case '-':
						return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationOperation();
					case '\'':
						return $stil4m$elm_syntax$Elm$Parser$Expression$charLiteralExpression;
					default:
						return $stil4m$elm_syntax$Elm$Parser$Expression$referenceOrNumberExpression;
				}
			}));
}
function $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpressionMaybeAppliedOptimisticLayout() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (leftExpressionResult, commentsBeforeExtension, maybeArgsReverse) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						maybeArgsReverse.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsBeforeExtension, leftExpressionResult.ao)),
					a: function () {
						var _v0 = maybeArgsReverse.a;
						if (!_v0.b) {
							return leftExpressionResult.a;
						} else {
							var argsReverse = _v0;
							var _v1 = argsReverse.a;
							var lastArgRange = _v1.a;
							var leftNode = leftExpressionResult.a;
							var leftRange = leftNode.a;
							return A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: lastArgRange.w, z: leftRange.z},
								$stil4m$elm_syntax$Elm$Syntax$Expression$Application(
									A2(
										$elm$core$List$cons,
										leftNode,
										$elm$core$List$reverse(argsReverse))));
						}
					}()
				};
			}),
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v2) {
				return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression();
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
			A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (arg, commentsAfter) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, arg.ao),
							a: arg.a
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy(
					$stil4m$elm_syntax$ParserFast$lazy(
						function (_v3) {
							return $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression();
						})),
				$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout)));
}
var $stil4m$elm_syntax$Elm$Parser$Expression$letOrUnqualifiedReferenceExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letOrUnqualifiedReferenceExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letOrUnqualifiedReferenceExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$letOrUnqualifiedReferenceExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$letExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$letExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$letDeclarationsIn = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDeclarationsIn();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDeclarationsIn = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$letDeclarationsIn;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$blockElement = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$blockElement();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$blockElement = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$blockElement;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$caseOrUnqualifiedReferenceExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseOrUnqualifiedReferenceExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseOrUnqualifiedReferenceExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$caseOrUnqualifiedReferenceExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$caseExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$caseExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$caseStatements = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatements();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatements = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$caseStatements;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$caseStatement = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatement();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$caseStatement = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$caseStatement;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$tupledExpressionIfNecessaryFollowedByRecordAccess = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionIfNecessaryFollowedByRecordAccess();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionIfNecessaryFollowedByRecordAccess = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$tupledExpressionIfNecessaryFollowedByRecordAccess;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$tupledExpressionInnerAfterOpeningParens = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionInnerAfterOpeningParens();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$tupledExpressionInnerAfterOpeningParens = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$tupledExpressionInnerAfterOpeningParens;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$recordExpressionFollowedByRecordAccess = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordExpressionFollowedByRecordAccess();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordExpressionFollowedByRecordAccess = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$recordExpressionFollowedByRecordAccess;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$recordContentsCurlyEnd = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordContentsCurlyEnd();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordContentsCurlyEnd = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$recordContentsCurlyEnd;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$recordFields = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordFields();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordFields = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$recordFields;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$recordSetterNodeWithLayout = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordSetterNodeWithLayout();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$recordSetterNodeWithLayout = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$recordSetterNodeWithLayout;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$letFunction = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letFunction();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letFunction = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$letFunction;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$letDestructuringDeclaration = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDestructuringDeclaration();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$letDestructuringDeclaration = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$letDestructuringDeclaration;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$lambdaExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$lambdaExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$lambdaExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$lambdaExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$ifOrUnqualifiedReferenceExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifOrUnqualifiedReferenceExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifOrUnqualifiedReferenceExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$ifOrUnqualifiedReferenceExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$ifBlockExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifBlockExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$ifBlockExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$ifBlockExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$listOrGlslExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$listOrGlslExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$listOrGlslExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$listOrGlslExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$expressionAfterOpeningSquareBracket = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expressionAfterOpeningSquareBracket();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expressionAfterOpeningSquareBracket = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$expressionAfterOpeningSquareBracket;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$expression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$expression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$expression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence9ComposeL = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeL();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeL = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence9ComposeL;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence8QuestionMark = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8QuestionMark();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8QuestionMark = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence8QuestionMark;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Mul = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Mul();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Mul = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Mul;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Idiv = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Idiv();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Idiv = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Idiv;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Fdiv = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Fdiv();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Fdiv = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Fdiv;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Sub = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Sub();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Sub = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Sub;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Ignore = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Ignore();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Ignore = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Ignore;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Add = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Add();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence6Add = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence6Add;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence5Keep = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Keep();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Keep = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence5Keep;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence1ApR = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApR();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApR = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence1ApR;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Neq = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Neq();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Neq = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Neq;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Lt = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Lt();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Lt = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Lt;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Le = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Le();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Le = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Le;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Gt = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Gt();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Gt = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Gt;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Ge = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Ge();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Ge = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Ge;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Eq = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Eq();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence4Eq = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence4Eq;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence9ComposeR = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeR();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence9ComposeR = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence9ComposeR;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence8Pow = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8Pow();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence8Pow = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence8Pow;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Slash = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Slash();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence7Slash = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence7Slash;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence5append = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5append();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5append = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence5append;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence5Cons = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Cons();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence5Cons = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence5Cons;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence3And = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence3And();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence3And = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence3And;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence2Or = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence2Or();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence2Or = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence2Or;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$precedence1ApL = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApL();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$precedence1ApL = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$precedence1ApL;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$negationAfterMinus = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationAfterMinus = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$negationAfterMinus;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$negationOperation = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationOperation();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$negationOperation = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$negationOperation;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$subExpression = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpression = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$subExpression;
};
var $stil4m$elm_syntax$Elm$Parser$Expression$subExpressionMaybeAppliedOptimisticLayout = $stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpressionMaybeAppliedOptimisticLayout();
$stil4m$elm_syntax$Elm$Parser$Expression$cyclic$subExpressionMaybeAppliedOptimisticLayout = function () {
	return $stil4m$elm_syntax$Elm$Parser$Expression$subExpressionMaybeAppliedOptimisticLayout;
};
var $elm$core$Maybe$map = F2(
	function (f, maybe) {
		if (!maybe.$) {
			var value = maybe.a;
			return $elm$core$Maybe$Just(
				f(value));
		} else {
			return $elm$core$Maybe$Nothing;
		}
	});
var $stil4m$elm_syntax$ParserFast$map6 = F7(
	function (func, _v0, _v1, _v2, _v3, _v4, _v5) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		var parseF = _v5;
		return function (s0) {
			var _v6 = parseA(s0);
			if (_v6.$ === 1) {
				var committed = _v6.a;
				var x = _v6.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v6.a;
				var s1 = _v6.b;
				var _v7 = parseB(s1);
				if (_v7.$ === 1) {
					var x = _v7.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v7.a;
					var s2 = _v7.b;
					var _v8 = parseC(s2);
					if (_v8.$ === 1) {
						var x = _v8.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v8.a;
						var s3 = _v8.b;
						var _v9 = parseD(s3);
						if (_v9.$ === 1) {
							var x = _v9.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v9.a;
							var s4 = _v9.b;
							var _v10 = parseE(s4);
							if (_v10.$ === 1) {
								var x = _v10.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v10.a;
								var s5 = _v10.b;
								var _v11 = parseF(s5);
								if (_v11.$ === 1) {
									var x = _v11.b;
									return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
								} else {
									var f = _v11.a;
									var s6 = _v11.b;
									return A2(
										$stil4m$elm_syntax$ParserFast$Good,
										A6(func, a, b, c, d, e, f),
										s6);
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Declarations$parameterPatternsEqual = A2(
	$stil4m$elm_syntax$ParserWithComments$until,
	$stil4m$elm_syntax$Elm$Parser$Tokens$equal,
	A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (patternResult, commentsAfterPattern) {
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterPattern, patternResult.ao),
					a: patternResult.a
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Patterns$patternNotDirectlyComposing,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout));
var $stil4m$elm_syntax$Elm$Parser$Declarations$functionAfterDocumentation = A7(
	$stil4m$elm_syntax$ParserFast$map6,
	F6(
		function (startName, commentsAfterStartName, maybeSignature, _arguments, commentsAfterEqual, result) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					result.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterEqual,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							_arguments.ao,
							function () {
								if (maybeSignature.$ === 1) {
									return commentsAfterStartName;
								} else {
									var signature = maybeSignature.a;
									return A2($stil4m$elm_syntax$Rope$prependTo, signature.ao, commentsAfterStartName);
								}
							}()))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$FunctionDeclarationAfterDocumentation(
					{
						Q: _arguments.a,
						E: result.a,
						ay: A2(
							$elm$core$Maybe$map,
							function ($) {
								return $.a;
							},
							maybeSignature),
						J: startName
					})
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	A6(
		$stil4m$elm_syntax$ParserFast$map4OrSucceed,
		F4(
			function (commentsBeforeTypeAnnotation, typeAnnotationResult, implementationName, afterImplementationName) {
				return $elm$core$Maybe$Just(
					{
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							afterImplementationName,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								implementationName.ao,
								A2($stil4m$elm_syntax$Rope$prependTo, typeAnnotationResult.ao, commentsBeforeTypeAnnotation))),
						a: {y: implementationName.a, ak: typeAnnotationResult.a}
					});
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation,
		$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedBy($stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode),
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$elm$core$Maybe$Nothing),
	$stil4m$elm_syntax$Elm$Parser$Declarations$parameterPatternsEqual,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Expression$expression);
var $stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedByWithComments = function (nextParser) {
	return A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (commentsBefore, after) {
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, after.ao, commentsBefore),
					a: after.a
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(nextParser));
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$PortDeclarationAfterDocumentation = function (a) {
	return {$: 3, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$portDeclarationAfterDocumentation = A6(
	$stil4m$elm_syntax$ParserFast$map5,
	F5(
		function (commentsAfterPort, name, commentsAfterName, commentsAfterColon, typeAnnotationResult) {
			var nameRange = name.a;
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					commentsAfterColon,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						typeAnnotationResult.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterName, commentsAfterPort))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$PortDeclarationAfterDocumentation(
					{
						N: name,
						ah: {p: 1, t: nameRange.z.t},
						ak: typeAnnotationResult.a
					})
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'port', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation);
var $stil4m$elm_syntax$Elm$Syntax$Node$range = function (_v0) {
	var r = _v0.a;
	return r;
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$TypeDeclarationAfterDocumentation = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$typeGenericListEquals = A2(
	$stil4m$elm_syntax$ParserWithComments$until,
	$stil4m$elm_syntax$Elm$Parser$Tokens$equal,
	A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (name, commentsAfterName) {
				return {ao: commentsAfterName, a: name};
			}),
		$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout));
var $stil4m$elm_syntax$ParserFast$ifFollowedByWhileMapWithRangeWithoutLinebreak = F3(
	function (rangeAndConsumedStringToRes, firstIsOkay, afterFirstIsOkay) {
		return function (s0) {
			var firstOffset = A3($stil4m$elm_syntax$ParserFast$isSubCharWithoutLinebreak, firstIsOkay, s0.c, s0.b);
			if (_Utils_eq(firstOffset, -1)) {
				return A2(
					$stil4m$elm_syntax$ParserFast$Bad,
					false,
					A2($stil4m$elm_syntax$ParserFast$ExpectingCharSatisfyingPredicate, s0.t, s0.S));
			} else {
				var s1 = A6($stil4m$elm_syntax$ParserFast$skipWhileWithoutLinebreakHelp, afterFirstIsOkay, firstOffset, s0.t, s0.S + 1, s0.b, s0.g);
				return A2(
					$stil4m$elm_syntax$ParserFast$Good,
					A2(
						rangeAndConsumedStringToRes,
						{
							w: {p: s1.S, t: s1.t},
							z: {p: s0.S, t: s0.t}
						},
						A3($elm$core$String$slice, s0.c, s1.c, s0.b)),
					s1);
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode = A3($stil4m$elm_syntax$ParserFast$ifFollowedByWhileMapWithRangeWithoutLinebreak, $stil4m$elm_syntax$Elm$Syntax$Node$Node, $stil4m$elm_syntax$Char$Extra$unicodeIsUpperFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast);
var $stil4m$elm_syntax$Elm$Parser$Declarations$valueConstructorOptimisticLayout = A4(
	$stil4m$elm_syntax$ParserFast$map3,
	F3(
		function (name, commentsAfterName, argumentsReverse) {
			var nameRange = name.a;
			var fullRange = function () {
				var _v0 = argumentsReverse.a;
				if (_v0.b) {
					var _v1 = _v0.a;
					var lastArgRange = _v1.a;
					return {w: lastArgRange.w, z: nameRange.z};
				} else {
					return nameRange;
				}
			}();
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, argumentsReverse.ao, commentsAfterName),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					fullRange,
					{
						Q: $elm$core$List$reverse(argumentsReverse.a),
						N: name
					})
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
	$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
		$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedFollowedBy(
			A3(
				$stil4m$elm_syntax$ParserFast$map2,
				F2(
					function (typeAnnotationResult, commentsAfter) {
						return {
							ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, typeAnnotationResult.ao),
							a: typeAnnotationResult.a
						};
					}),
				$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotationNoFnExcludingTypedWithArguments,
				$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout))));
var $stil4m$elm_syntax$Elm$Parser$Declarations$customTypeDefinitionAfterDocumentationAfterTypePrefix = A7(
	$stil4m$elm_syntax$ParserFast$map6,
	F6(
		function (name, commentsAfterName, parameters, commentsAfterEqual, headVariant, tailVariantsReverse) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					tailVariantsReverse.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						headVariant.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsAfterEqual,
							A2($stil4m$elm_syntax$Rope$prependTo, parameters.ao, commentsAfterName)))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$TypeDeclarationAfterDocumentation(
					{x: headVariant.a, N: name, s: parameters.a, A: tailVariantsReverse.a})
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$typeGenericListEquals,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$valueConstructorOptimisticLayout,
	$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'|',
			A2(
				$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedPlusFollowedBy,
				1,
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (commentsBeforePipe, variantResult) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, variantResult.ao, commentsBeforePipe),
								a: variantResult.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$Elm$Parser$Declarations$valueConstructorOptimisticLayout)))));
var $stil4m$elm_syntax$Elm$Parser$Declarations$TypeAliasDeclarationAfterDocumentation = function (a) {
	return {$: 2, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$typeAliasDefinitionAfterDocumentationAfterTypePrefix = A7(
	$stil4m$elm_syntax$ParserFast$map6,
	F6(
		function (commentsAfterAlias, name, commentsAfterName, parameters, commentsAfterEquals, typeAnnotationResult) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					typeAnnotationResult.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterEquals,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							parameters.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterName, commentsAfterAlias)))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$TypeAliasDeclarationAfterDocumentation(
					{N: name, s: parameters.a, ak: typeAnnotationResult.a})
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'alias', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$typeGenericListEquals,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation);
var $stil4m$elm_syntax$Elm$Parser$Declarations$typeOrTypeAliasDefinitionAfterDocumentation = A3(
	$stil4m$elm_syntax$ParserFast$map2,
	F2(
		function (commentsAfterType, declarationAfterDocumentation) {
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, declarationAfterDocumentation.ao, commentsAfterType),
				a: declarationAfterDocumentation.a
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'type', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2($stil4m$elm_syntax$ParserFast$oneOf2, $stil4m$elm_syntax$Elm$Parser$Declarations$typeAliasDefinitionAfterDocumentationAfterTypePrefix, $stil4m$elm_syntax$Elm$Parser$Declarations$customTypeDefinitionAfterDocumentationAfterTypePrefix));
var $stil4m$elm_syntax$Elm$Parser$Declarations$declarationWithDocumentation = A3(
	$stil4m$elm_syntax$ParserFast$validate,
	function (result) {
		var _v11 = result.a;
		var decl = _v11.b;
		if (!decl.$) {
			var letFunctionDeclaration = decl.a;
			var _v13 = letFunctionDeclaration.ay;
			if (_v13.$ === 1) {
				return true;
			} else {
				var _v14 = _v13.a;
				var signature = _v14.b;
				var _v15 = signature.N;
				var signatureName = _v15.b;
				var _v16 = letFunctionDeclaration.ar;
				var implementation = _v16.b;
				var _v17 = implementation.N;
				var implementationName = _v17.b;
				return _Utils_eq(implementationName, signatureName + '');
			}
		} else {
			return true;
		}
	},
	'Expected to find the same name for declaration and signature',
	A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (documentation, afterDocumentation) {
				var start = $stil4m$elm_syntax$Elm$Syntax$Node$range(documentation).z;
				var _v0 = afterDocumentation.a;
				switch (_v0.$) {
					case 0:
						var functionDeclarationAfterDocumentation = _v0.a;
						var _v1 = functionDeclarationAfterDocumentation.ay;
						if (!_v1.$) {
							var signature = _v1.a;
							var _v2 = signature.y;
							var implementationNameRange = _v2.a;
							var _v3 = functionDeclarationAfterDocumentation.E;
							var expressionRange = _v3.a;
							return {
								ao: afterDocumentation.ao,
								a: A2(
									$stil4m$elm_syntax$Elm$Syntax$Node$Node,
									{w: expressionRange.w, z: start},
									$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
										{
											ar: A2(
												$stil4m$elm_syntax$Elm$Syntax$Node$Node,
												{w: expressionRange.w, z: implementationNameRange.z},
												{Q: functionDeclarationAfterDocumentation.Q, E: functionDeclarationAfterDocumentation.E, N: signature.y}),
											K: $elm$core$Maybe$Just(documentation),
											ay: $elm$core$Maybe$Just(
												A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$Signature$Signature, functionDeclarationAfterDocumentation.J, signature.ak))
										}))
							};
						} else {
							var _v4 = functionDeclarationAfterDocumentation.J;
							var startNameRange = _v4.a;
							var _v5 = functionDeclarationAfterDocumentation.E;
							var expressionRange = _v5.a;
							return {
								ao: afterDocumentation.ao,
								a: A2(
									$stil4m$elm_syntax$Elm$Syntax$Node$Node,
									{w: expressionRange.w, z: start},
									$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
										{
											ar: A2(
												$stil4m$elm_syntax$Elm$Syntax$Node$Node,
												{w: expressionRange.w, z: startNameRange.z},
												{Q: functionDeclarationAfterDocumentation.Q, E: functionDeclarationAfterDocumentation.E, N: functionDeclarationAfterDocumentation.J}),
											K: $elm$core$Maybe$Just(documentation),
											ay: $elm$core$Maybe$Nothing
										}))
							};
						}
					case 1:
						var typeDeclarationAfterDocumentation = _v0.a;
						var end = function () {
							var _v6 = typeDeclarationAfterDocumentation.A;
							if (_v6.b) {
								var _v7 = _v6.a;
								var range = _v7.a;
								return range.w;
							} else {
								var _v8 = typeDeclarationAfterDocumentation.x;
								var headVariantRange = _v8.a;
								return headVariantRange.w;
							}
						}();
						return {
							ao: afterDocumentation.ao,
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: end, z: start},
								$stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration(
									{
										ap: A2(
											$elm$core$List$cons,
											typeDeclarationAfterDocumentation.x,
											$elm$core$List$reverse(typeDeclarationAfterDocumentation.A)),
										K: $elm$core$Maybe$Just(documentation),
										X: typeDeclarationAfterDocumentation.s,
										N: typeDeclarationAfterDocumentation.N
									}))
						};
					case 2:
						var typeAliasDeclarationAfterDocumentation = _v0.a;
						var _v9 = typeAliasDeclarationAfterDocumentation.ak;
						var typeAnnotationRange = _v9.a;
						return {
							ao: afterDocumentation.ao,
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: typeAnnotationRange.w, z: start},
								$stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration(
									{
										K: $elm$core$Maybe$Just(documentation),
										X: typeAliasDeclarationAfterDocumentation.s,
										N: typeAliasDeclarationAfterDocumentation.N,
										ak: typeAliasDeclarationAfterDocumentation.ak
									}))
						};
					default:
						var portDeclarationAfterName = _v0.a;
						var _v10 = portDeclarationAfterName.ak;
						var typeAnnotationRange = _v10.a;
						return {
							ao: A2(
								$stil4m$elm_syntax$Rope$filledPrependTo,
								afterDocumentation.ao,
								$stil4m$elm_syntax$Rope$one(documentation)),
							a: A2(
								$stil4m$elm_syntax$Elm$Syntax$Node$Node,
								{w: typeAnnotationRange.w, z: portDeclarationAfterName.ah},
								$stil4m$elm_syntax$Elm$Syntax$Declaration$PortDeclaration(
									{N: portDeclarationAfterName.N, ak: portDeclarationAfterName.ak}))
						};
				}
			}),
		$stil4m$elm_syntax$Elm$Parser$Comments$declarationDocumentation,
		$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedByWithComments(
			A3($stil4m$elm_syntax$ParserFast$oneOf3, $stil4m$elm_syntax$Elm$Parser$Declarations$functionAfterDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$typeOrTypeAliasDefinitionAfterDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$portDeclarationAfterDocumentation))));
var $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNotInfixNode = A4(
	$stil4m$elm_syntax$ParserFast$ifFollowedByWhileValidateMapWithRangeWithoutLinebreak,
	$stil4m$elm_syntax$Elm$Syntax$Node$Node,
	$stil4m$elm_syntax$Char$Extra$unicodeIsLowerFast,
	$stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast,
	function (name) {
		return (name !== 'infix') && $stil4m$elm_syntax$Elm$Parser$Tokens$isNotReserved(name);
	});
var $stil4m$elm_syntax$Elm$Parser$Declarations$functionDeclarationWithoutDocumentation = A3(
	$stil4m$elm_syntax$ParserFast$validate,
	function (result) {
		var _v5 = result.a;
		var decl = _v5.b;
		if (!decl.$) {
			var letFunctionDeclaration = decl.a;
			var _v7 = letFunctionDeclaration.ay;
			if (_v7.$ === 1) {
				return true;
			} else {
				var _v8 = _v7.a;
				var signature = _v8.b;
				var _v9 = signature.N;
				var signatureName = _v9.b;
				var _v10 = letFunctionDeclaration.ar;
				var implementation = _v10.b;
				var _v11 = implementation.N;
				var implementationName = _v11.b;
				return _Utils_eq(implementationName, signatureName + '');
			}
		} else {
			return true;
		}
	},
	'Expected to find the same name for declaration and signature',
	A7(
		$stil4m$elm_syntax$ParserFast$map6WithStartLocation,
		F7(
			function (startNameStart, startNameNode, commentsAfterStartName, maybeSignature, _arguments, commentsAfterEqual, result) {
				var allComments = A2(
					$stil4m$elm_syntax$Rope$prependTo,
					result.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterEqual,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							_arguments.ao,
							function () {
								if (maybeSignature.$ === 1) {
									return commentsAfterStartName;
								} else {
									var signature = maybeSignature.a;
									return A2($stil4m$elm_syntax$Rope$prependTo, signature.ao, commentsAfterStartName);
								}
							}())));
				if (maybeSignature.$ === 1) {
					var _v1 = result.a;
					var expressionRange = _v1.a;
					return {
						ao: allComments,
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: expressionRange.w, z: startNameStart},
							$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
								{
									ar: A2(
										$stil4m$elm_syntax$Elm$Syntax$Node$Node,
										{w: expressionRange.w, z: startNameStart},
										{Q: _arguments.a, E: result.a, N: startNameNode}),
									K: $elm$core$Maybe$Nothing,
									ay: $elm$core$Maybe$Nothing
								}))
					};
				} else {
					var signature = maybeSignature.a;
					var _v2 = signature.y;
					var implementationNameRange = _v2.a;
					var _v3 = result.a;
					var expressionRange = _v3.a;
					return {
						ao: allComments,
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: expressionRange.w, z: startNameStart},
							$stil4m$elm_syntax$Elm$Syntax$Declaration$FunctionDeclaration(
								{
									ar: A2(
										$stil4m$elm_syntax$Elm$Syntax$Node$Node,
										{w: expressionRange.w, z: implementationNameRange.z},
										{Q: _arguments.a, E: result.a, N: signature.y}),
									K: $elm$core$Maybe$Nothing,
									ay: $elm$core$Maybe$Just(
										A3($stil4m$elm_syntax$Elm$Syntax$Node$combine, $stil4m$elm_syntax$Elm$Syntax$Signature$Signature, startNameNode, signature.ak))
								}))
					};
				}
			}),
		$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNotInfixNode,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		A6(
			$stil4m$elm_syntax$ParserFast$map4OrSucceed,
			F4(
				function (commentsBeforeTypeAnnotation, typeAnnotationResult, implementationName, afterImplementationName) {
					return $elm$core$Maybe$Just(
						{
							ao: A2(
								$stil4m$elm_syntax$Rope$prependTo,
								afterImplementationName,
								A2(
									$stil4m$elm_syntax$Rope$prependTo,
									implementationName.ao,
									A2($stil4m$elm_syntax$Rope$prependTo, typeAnnotationResult.ao, commentsBeforeTypeAnnotation))),
							y: implementationName.a,
							ak: typeAnnotationResult.a
						});
				}),
			A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
			$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation,
			$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedBy($stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$elm$core$Maybe$Nothing),
		$stil4m$elm_syntax$Elm$Parser$Declarations$parameterPatternsEqual,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$Elm$Parser$Expression$expression));
var $stil4m$elm_syntax$Elm$Parser$Declarations$infixDirection = A3(
	$stil4m$elm_syntax$ParserFast$oneOf3,
	A2(
		$stil4m$elm_syntax$ParserFast$mapWithRange,
		$stil4m$elm_syntax$Elm$Syntax$Node$Node,
		A2($stil4m$elm_syntax$ParserFast$keyword, 'right', 1)),
	A2(
		$stil4m$elm_syntax$ParserFast$mapWithRange,
		$stil4m$elm_syntax$Elm$Syntax$Node$Node,
		A2($stil4m$elm_syntax$ParserFast$keyword, 'left', 0)),
	A2(
		$stil4m$elm_syntax$ParserFast$mapWithRange,
		$stil4m$elm_syntax$Elm$Syntax$Node$Node,
		A2($stil4m$elm_syntax$ParserFast$keyword, 'non', 2)));
var $stil4m$elm_syntax$ParserFast$errorAsOffsetAndInt = {_: 0, c: -1};
var $stil4m$elm_syntax$ParserFast$convertIntegerDecimal = F2(
	function (offset, src) {
		var _v0 = A3($elm$core$String$slice, offset, offset + 1, src);
		switch (_v0) {
			case '0':
				return {_: 0, c: offset + 1};
			case '1':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 1, offset + 1, src);
			case '2':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 2, offset + 1, src);
			case '3':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 3, offset + 1, src);
			case '4':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 4, offset + 1, src);
			case '5':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 5, offset + 1, src);
			case '6':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 6, offset + 1, src);
			case '7':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 7, offset + 1, src);
			case '8':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 8, offset + 1, src);
			case '9':
				return A3($stil4m$elm_syntax$ParserFast$convert0OrMore0To9s, 9, offset + 1, src);
			default:
				return $stil4m$elm_syntax$ParserFast$errorAsOffsetAndInt;
		}
	});
var $stil4m$elm_syntax$ParserFast$integerDecimalMapWithRange = function (rangeAndIntToRes) {
	return function (s0) {
		var s1 = A2($stil4m$elm_syntax$ParserFast$convertIntegerDecimal, s0.c, s0.b);
		if (_Utils_eq(s1.c, -1)) {
			return A2(
				$stil4m$elm_syntax$ParserFast$Bad,
				false,
				A2($stil4m$elm_syntax$ParserFast$ExpectingNumber, s0.t, s0.S));
		} else {
			var newColumn = s0.S + (s1.c - s0.c);
			return A2(
				$stil4m$elm_syntax$ParserFast$Good,
				A2(
					rangeAndIntToRes,
					{
						w: {p: newColumn, t: s0.t},
						z: {p: s0.S, t: s0.t}
					},
					s1._),
				{S: newColumn, g: s0.g, c: s1.c, t: s0.t, b: s0.b});
		}
	};
};
var $stil4m$elm_syntax$ParserFast$map9WithRange = function (func) {
	return function (_v0) {
		return function (_v1) {
			return function (_v2) {
				return function (_v3) {
					return function (_v4) {
						return function (_v5) {
							return function (_v6) {
								return function (_v7) {
									return function (_v8) {
										var parseA = _v0;
										var parseB = _v1;
										var parseC = _v2;
										var parseD = _v3;
										var parseE = _v4;
										var parseF = _v5;
										var parseG = _v6;
										var parseH = _v7;
										var parseI = _v8;
										return function (s0) {
											var _v9 = parseA(s0);
											if (_v9.$ === 1) {
												var committed = _v9.a;
												var x = _v9.b;
												return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
											} else {
												var a = _v9.a;
												var s1 = _v9.b;
												var _v10 = parseB(s1);
												if (_v10.$ === 1) {
													var x = _v10.b;
													return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
												} else {
													var b = _v10.a;
													var s2 = _v10.b;
													var _v11 = parseC(s2);
													if (_v11.$ === 1) {
														var x = _v11.b;
														return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
													} else {
														var c = _v11.a;
														var s3 = _v11.b;
														var _v12 = parseD(s3);
														if (_v12.$ === 1) {
															var x = _v12.b;
															return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
														} else {
															var d = _v12.a;
															var s4 = _v12.b;
															var _v13 = parseE(s4);
															if (_v13.$ === 1) {
																var x = _v13.b;
																return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
															} else {
																var e = _v13.a;
																var s5 = _v13.b;
																var _v14 = parseF(s5);
																if (_v14.$ === 1) {
																	var x = _v14.b;
																	return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
																} else {
																	var f = _v14.a;
																	var s6 = _v14.b;
																	var _v15 = parseG(s6);
																	if (_v15.$ === 1) {
																		var x = _v15.b;
																		return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
																	} else {
																		var g = _v15.a;
																		var s7 = _v15.b;
																		var _v16 = parseH(s7);
																		if (_v16.$ === 1) {
																			var x = _v16.b;
																			return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
																		} else {
																			var h = _v16.a;
																			var s8 = _v16.b;
																			var _v17 = parseI(s8);
																			if (_v17.$ === 1) {
																				var x = _v17.b;
																				return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
																			} else {
																				var i = _v17.a;
																				var s9 = _v17.b;
																				return A2(
																					$stil4m$elm_syntax$ParserFast$Good,
																					func(
																						{
																							w: {p: s9.S, t: s9.t},
																							z: {p: s0.S, t: s0.t}
																						})(a)(b)(c)(d)(e)(f)(g)(h)(i),
																					s9);
																			}
																		}
																	}
																}
															}
														}
													}
												}
											}
										};
									};
								};
							};
						};
					};
				};
			};
		};
	};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$infixDeclaration = $stil4m$elm_syntax$ParserFast$map9WithRange(
	function (range) {
		return function (commentsAfterInfix) {
			return function (direction) {
				return function (commentsAfterDirection) {
					return function (precedence) {
						return function (commentsAfterPrecedence) {
							return function (operator) {
								return function (commentsAfterOperator) {
									return function (commentsAfterEqual) {
										return function (fn) {
											return {
												ao: A2(
													$stil4m$elm_syntax$Rope$prependTo,
													commentsAfterEqual,
													A2(
														$stil4m$elm_syntax$Rope$prependTo,
														commentsAfterOperator,
														A2(
															$stil4m$elm_syntax$Rope$prependTo,
															commentsAfterPrecedence,
															A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterDirection, commentsAfterInfix)))),
												a: A2(
													$stil4m$elm_syntax$Elm$Syntax$Node$Node,
													range,
													$stil4m$elm_syntax$Elm$Syntax$Declaration$InfixDeclaration(
														{e: direction, f: fn, h: operator, i: precedence}))
											};
										};
									};
								};
							};
						};
					};
				};
			};
		};
	})(
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'infix', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))($stil4m$elm_syntax$Elm$Parser$Declarations$infixDirection)($stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)(
	$stil4m$elm_syntax$ParserFast$integerDecimalMapWithRange($stil4m$elm_syntax$Elm$Syntax$Node$Node))($stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)(
	A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'(',
		A4(
			$stil4m$elm_syntax$ParserFast$whileWithoutLinebreakAnd2PartUtf16ValidateMapWithRangeBacktrackableFollowedBySymbol,
			F2(
				function (operatorRange, operator) {
					return A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						{
							w: {p: operatorRange.w.p + 1, t: operatorRange.w.t},
							z: {p: operatorRange.z.p - 1, t: operatorRange.z.t}
						},
						operator);
				}),
			$stil4m$elm_syntax$Elm$Parser$Tokens$isOperatorSymbolChar,
			$stil4m$elm_syntax$Elm$Parser$Tokens$isAllowedOperatorToken,
			')')))($stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)(
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '=', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout))($stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode);
var $stil4m$elm_syntax$ParserFast$oneOf5 = F5(
	function (_v0, _v1, _v2, _v3, _v4) {
		var attemptFirst = _v0;
		var attemptSecond = _v1;
		var attemptThird = _v2;
		var attemptFourth = _v3;
		var attemptFifth = _v4;
		return function (s) {
			var _v5 = attemptFirst(s);
			if (!_v5.$) {
				var firstGood = _v5;
				return firstGood;
			} else {
				var firstBad = _v5;
				var firstCommitted = firstBad.a;
				var firstX = firstBad.b;
				if (firstCommitted) {
					return firstBad;
				} else {
					var _v6 = attemptSecond(s);
					if (!_v6.$) {
						var secondGood = _v6;
						return secondGood;
					} else {
						var secondBad = _v6;
						var secondCommitted = secondBad.a;
						var secondX = secondBad.b;
						if (secondCommitted) {
							return secondBad;
						} else {
							var _v7 = attemptThird(s);
							if (!_v7.$) {
								var thirdGood = _v7;
								return thirdGood;
							} else {
								var thirdBad = _v7;
								var thirdCommitted = thirdBad.a;
								var thirdX = thirdBad.b;
								if (thirdCommitted) {
									return thirdBad;
								} else {
									var _v8 = attemptFourth(s);
									if (!_v8.$) {
										var fourthGood = _v8;
										return fourthGood;
									} else {
										var fourthBad = _v8;
										var fourthCommitted = fourthBad.a;
										var fourthX = fourthBad.b;
										if (fourthCommitted) {
											return fourthBad;
										} else {
											var _v9 = attemptFifth(s);
											if (!_v9.$) {
												var fifthGood = _v9;
												return fifthGood;
											} else {
												var fifthBad = _v9;
												var fifthCommitted = fifthBad.a;
												var fifthX = fifthBad.b;
												return fifthCommitted ? fifthBad : A2(
													$stil4m$elm_syntax$ParserFast$Bad,
													false,
													A3(
														$stil4m$elm_syntax$ParserFast$ExpectingOneOf,
														firstX,
														secondX,
														_List_fromArray(
															[thirdX, fourthX, fifthX])));
											}
										}
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Declarations$portDeclarationWithoutDocumentation = A6(
	$stil4m$elm_syntax$ParserFast$map5,
	F5(
		function (commentsAfterPort, name, commentsAfterName, commentsAfterColon, typeAnnotationResult) {
			var nameRange = name.a;
			var _v0 = typeAnnotationResult.a;
			var end = _v0.a.w;
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					typeAnnotationResult.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterColon,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterName, commentsAfterPort))),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					{
						w: end,
						z: {p: 1, t: nameRange.z.t}
					},
					$stil4m$elm_syntax$Elm$Syntax$Declaration$PortDeclaration(
						{N: name, ak: typeAnnotationResult.a}))
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'port', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, ':', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation);
var $stil4m$elm_syntax$Elm$Parser$Declarations$TypeDeclarationWithoutDocumentation = function (a) {
	return {$: 0, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$customTypeDefinitionWithoutDocumentationAfterTypePrefix = A7(
	$stil4m$elm_syntax$ParserFast$map6,
	F6(
		function (name, commentsAfterName, parameters, commentsAfterEqual, headVariant, tailVariantsReverse) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					tailVariantsReverse.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						headVariant.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							commentsAfterEqual,
							A2($stil4m$elm_syntax$Rope$prependTo, parameters.ao, commentsAfterName)))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$TypeDeclarationWithoutDocumentation(
					{x: headVariant.a, N: name, s: parameters.a, A: tailVariantsReverse.a})
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$typeGenericListEquals,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$valueConstructorOptimisticLayout,
	$stil4m$elm_syntax$ParserWithComments$manyWithoutReverse(
		A2(
			$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
			'|',
			A2(
				$stil4m$elm_syntax$Elm$Parser$Layout$positivelyIndentedPlusFollowedBy,
				1,
				A3(
					$stil4m$elm_syntax$ParserFast$map2,
					F2(
						function (commentsBeforePipe, variantResult) {
							return {
								ao: A2($stil4m$elm_syntax$Rope$prependTo, variantResult.ao, commentsBeforePipe),
								a: variantResult.a
							};
						}),
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
					$stil4m$elm_syntax$Elm$Parser$Declarations$valueConstructorOptimisticLayout)))));
var $stil4m$elm_syntax$ParserFast$map2WithStartLocation = F3(
	function (func, _v0, _v1) {
		var parseA = _v0;
		var parseB = _v1;
		return function (s0) {
			var _v2 = parseA(s0);
			if (_v2.$ === 1) {
				var committed = _v2.a;
				var x = _v2.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v2.a;
				var s1 = _v2.b;
				var _v3 = parseB(s1);
				if (_v3.$ === 1) {
					var x = _v3.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v3.a;
					var s2 = _v3.b;
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						A3(
							func,
							{p: s0.S, t: s0.t},
							a,
							b),
						s2);
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Declarations$TypeAliasDeclarationWithoutDocumentation = function (a) {
	return {$: 1, a: a};
};
var $stil4m$elm_syntax$Elm$Parser$Declarations$typeAliasDefinitionWithoutDocumentationAfterTypePrefix = A7(
	$stil4m$elm_syntax$ParserFast$map6,
	F6(
		function (commentsAfterAlias, name, commentsAfterName, parameters, commentsAfterEqual, typeAnnotationResult) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					typeAnnotationResult.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterEqual,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							parameters.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterName, commentsAfterAlias)))),
				a: $stil4m$elm_syntax$Elm$Parser$Declarations$TypeAliasDeclarationWithoutDocumentation(
					{N: name, s: parameters.a, ak: typeAnnotationResult.a})
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'alias', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Declarations$typeGenericListEquals,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$TypeAnnotation$typeAnnotation);
var $stil4m$elm_syntax$Elm$Parser$Declarations$typeOrTypeAliasDefinitionWithoutDocumentation = A3(
	$stil4m$elm_syntax$ParserFast$map2WithStartLocation,
	F3(
		function (start, commentsAfterType, afterStart) {
			var allComments = A2($stil4m$elm_syntax$Rope$prependTo, afterStart.ao, commentsAfterType);
			var _v0 = afterStart.a;
			if (!_v0.$) {
				var typeDeclarationAfterDocumentation = _v0.a;
				var end = function () {
					var _v1 = typeDeclarationAfterDocumentation.A;
					if (_v1.b) {
						var _v2 = _v1.a;
						var range = _v2.a;
						return range.w;
					} else {
						var _v3 = typeDeclarationAfterDocumentation.x;
						var headVariantRange = _v3.a;
						return headVariantRange.w;
					}
				}();
				return {
					ao: allComments,
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						{w: end, z: start},
						$stil4m$elm_syntax$Elm$Syntax$Declaration$CustomTypeDeclaration(
							{
								ap: A2(
									$elm$core$List$cons,
									typeDeclarationAfterDocumentation.x,
									$elm$core$List$reverse(typeDeclarationAfterDocumentation.A)),
								K: $elm$core$Maybe$Nothing,
								X: typeDeclarationAfterDocumentation.s,
								N: typeDeclarationAfterDocumentation.N
							}))
				};
			} else {
				var typeAliasDeclarationAfterDocumentation = _v0.a;
				var _v4 = typeAliasDeclarationAfterDocumentation.ak;
				var typeAnnotationRange = _v4.a;
				return {
					ao: allComments,
					a: A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						{w: typeAnnotationRange.w, z: start},
						$stil4m$elm_syntax$Elm$Syntax$Declaration$AliasDeclaration(
							{K: $elm$core$Maybe$Nothing, X: typeAliasDeclarationAfterDocumentation.s, N: typeAliasDeclarationAfterDocumentation.N, ak: typeAliasDeclarationAfterDocumentation.ak}))
				};
			}
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'type', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2($stil4m$elm_syntax$ParserFast$oneOf2, $stil4m$elm_syntax$Elm$Parser$Declarations$typeAliasDefinitionWithoutDocumentationAfterTypePrefix, $stil4m$elm_syntax$Elm$Parser$Declarations$customTypeDefinitionWithoutDocumentationAfterTypePrefix));
var $stil4m$elm_syntax$Elm$Parser$Declarations$declaration = A5($stil4m$elm_syntax$ParserFast$oneOf5, $stil4m$elm_syntax$Elm$Parser$Declarations$functionDeclarationWithoutDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$declarationWithDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$typeOrTypeAliasDefinitionWithoutDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$portDeclarationWithoutDocumentation, $stil4m$elm_syntax$Elm$Parser$Declarations$infixDeclaration);
var $stil4m$elm_syntax$ParserFast$columnAndThen = function (callback) {
	return function (s) {
		var _v0 = callback(s.S);
		var parse = _v0;
		return parse(s);
	};
};
var $stil4m$elm_syntax$Elm$Parser$Layout$problemModuleLevelIndentation = $stil4m$elm_syntax$ParserFast$problem('must be on module-level indentation');
var $stil4m$elm_syntax$Elm$Parser$Layout$moduleLevelIndentationFollowedBy = function (nextParser) {
	return $stil4m$elm_syntax$ParserFast$columnAndThen(
		function (column) {
			return (column === 1) ? nextParser : $stil4m$elm_syntax$Elm$Parser$Layout$problemModuleLevelIndentation;
		});
};
var $stil4m$elm_syntax$Elm$Parser$File$fileDeclarations = $stil4m$elm_syntax$ParserWithComments$many(
	$stil4m$elm_syntax$Elm$Parser$Layout$moduleLevelIndentationFollowedBy(
		A3(
			$stil4m$elm_syntax$ParserFast$map2,
			F2(
				function (declarationParsed, commentsAfter) {
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, declarationParsed.ao),
						a: declarationParsed.a
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Declarations$declaration,
			$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout)));
var $stil4m$elm_syntax$Elm$Parser$Expose$functionExpose = $stil4m$elm_syntax$Elm$Parser$Tokens$functionNameMapWithRange(
	F2(
		function (range, name) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Exposing$FunctionExpose(name))
			};
		}));
var $stil4m$elm_syntax$Elm$Parser$Tokens$parensEnd = A2($stil4m$elm_syntax$ParserFast$symbol, ')', 0);
var $stil4m$elm_syntax$Elm$Parser$Expose$infixExpose = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, infixName, _v0) {
			return {
				ao: $stil4m$elm_syntax$Rope$empty,
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Exposing$InfixExpose(infixName))
			};
		}),
	A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'(',
		A2(
			$stil4m$elm_syntax$ParserFast$ifFollowedByWhileWithoutLinebreak,
			function (c) {
				switch (c) {
					case ')':
						return false;
					case '\n':
						return false;
					case ' ':
						return false;
					default:
						return true;
				}
			},
			function (c) {
				switch (c) {
					case ')':
						return false;
					case '\n':
						return false;
					case ' ':
						return false;
					default:
						return true;
				}
			})),
	$stil4m$elm_syntax$Elm$Parser$Tokens$parensEnd);
var $stil4m$elm_syntax$ParserFast$map2WithRangeOrSucceed = F4(
	function (func, _v0, _v1, fallback) {
		var parseA = _v0;
		var parseB = _v1;
		return function (s0) {
			var _v2 = parseA(s0);
			if (_v2.$ === 1) {
				var c1 = _v2.a;
				var x = _v2.b;
				return c1 ? A2($stil4m$elm_syntax$ParserFast$Bad, true, x) : A2($stil4m$elm_syntax$ParserFast$Good, fallback, s0);
			} else {
				var a = _v2.a;
				var s1 = _v2.b;
				var _v3 = parseB(s1);
				if (_v3.$ === 1) {
					var x = _v3.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v3.a;
					var s2 = _v3.b;
					return A2(
						$stil4m$elm_syntax$ParserFast$Good,
						A3(
							func,
							{
								w: {p: s2.S, t: s2.t},
								z: {p: s0.S, t: s0.t}
							},
							a,
							b),
						s2);
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Expose$typeExpose = A4(
	$stil4m$elm_syntax$ParserFast$map3,
	F3(
		function (_v0, commentsBeforeMaybeOpen, maybeOpen) {
			var typeNameRange = _v0.a;
			var typeName = _v0.b;
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, maybeOpen.ao, commentsBeforeMaybeOpen),
				a: function () {
					var _v1 = maybeOpen.a;
					if (_v1.$ === 1) {
						return A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							typeNameRange,
							$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeOrAliasExpose(typeName));
					} else {
						var openRange = _v1.a;
						return A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: openRange.w, z: typeNameRange.z},
							$stil4m$elm_syntax$Elm$Syntax$Exposing$TypeExpose(
								{N: typeName, ax: maybeOpen.a}));
					}
				}()
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode,
	$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
	A4(
		$stil4m$elm_syntax$ParserFast$map2WithRangeOrSucceed,
		F3(
			function (range, left, right) {
				return {
					ao: A2($stil4m$elm_syntax$Rope$prependTo, right, left),
					a: $elm$core$Maybe$Just(range)
				};
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '(', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		A2(
			$stil4m$elm_syntax$ParserFast$followedBySymbol,
			')',
			A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '..', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)),
		{ao: $stil4m$elm_syntax$Rope$empty, a: $elm$core$Maybe$Nothing}));
var $stil4m$elm_syntax$Elm$Parser$Expose$exposable = A3($stil4m$elm_syntax$ParserFast$oneOf3, $stil4m$elm_syntax$Elm$Parser$Expose$functionExpose, $stil4m$elm_syntax$Elm$Parser$Expose$typeExpose, $stil4m$elm_syntax$Elm$Parser$Expose$infixExpose);
var $stil4m$elm_syntax$Elm$Parser$Expose$exposingListInner = A2(
	$stil4m$elm_syntax$ParserFast$oneOf2,
	A4(
		$stil4m$elm_syntax$ParserFast$map3,
		F3(
			function (headElement, commentsAfterHeadElement, tailElements) {
				return {
					ao: A2(
						$stil4m$elm_syntax$Rope$prependTo,
						tailElements.ao,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterHeadElement, headElement.ao)),
					a: $stil4m$elm_syntax$Elm$Syntax$Exposing$Explicit(
						A2($elm$core$List$cons, headElement.a, tailElements.a))
				};
			}),
		$stil4m$elm_syntax$Elm$Parser$Expose$exposable,
		$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
		$stil4m$elm_syntax$ParserWithComments$many(
			A2(
				$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
				',',
				$stil4m$elm_syntax$Elm$Parser$Layout$maybeAroundBothSides($stil4m$elm_syntax$Elm$Parser$Expose$exposable)))),
	A2(
		$stil4m$elm_syntax$ParserFast$mapWithRange,
		F2(
			function (range, commentsAfterDotDot) {
				return {
					ao: commentsAfterDotDot,
					a: $stil4m$elm_syntax$Elm$Syntax$Exposing$All(range)
				};
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '..', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout)));
var $stil4m$elm_syntax$Elm$Parser$Expose$exposeDefinition = A4(
	$stil4m$elm_syntax$ParserFast$map3WithRange,
	F4(
		function (range, commentsAfterExposing, commentsBefore, exposingListInnerResult) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					exposingListInnerResult.ao,
					A2($stil4m$elm_syntax$Rope$prependTo, commentsBefore, commentsAfterExposing)),
				a: A2($stil4m$elm_syntax$Elm$Syntax$Node$Node, range, exposingListInnerResult.a)
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, 'exposing', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '(', $stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout),
	A2($stil4m$elm_syntax$ParserFast$followedBySymbol, ')', $stil4m$elm_syntax$Elm$Parser$Expose$exposingListInner));
var $stil4m$elm_syntax$ParserFast$map3OrSucceed = F5(
	function (func, _v0, _v1, _v2, fallback) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		return function (s0) {
			var _v3 = parseA(s0);
			if (_v3.$ === 1) {
				var c1 = _v3.a;
				var x = _v3.b;
				return c1 ? A2($stil4m$elm_syntax$ParserFast$Bad, true, x) : A2($stil4m$elm_syntax$ParserFast$Good, fallback, s0);
			} else {
				var a = _v3.a;
				var s1 = _v3.b;
				var _v4 = parseB(s1);
				if (_v4.$ === 1) {
					var x = _v4.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v4.a;
					var s2 = _v4.b;
					var _v5 = parseC(s2);
					if (_v5.$ === 1) {
						var x = _v5.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v5.a;
						var s3 = _v5.b;
						return A2(
							$stil4m$elm_syntax$ParserFast$Good,
							A3(func, a, b, c),
							s3);
					}
				}
			}
		};
	});
function $stil4m$elm_syntax$Elm$Parser$Base$cyclic$moduleNameOrEmpty() {
	return A4(
		$stil4m$elm_syntax$ParserFast$map2OrSucceed,
		F2(
			function (head, tail) {
				return A2($elm$core$List$cons, head, tail);
			}),
		A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '.', $stil4m$elm_syntax$Elm$Parser$Tokens$typeName),
		$stil4m$elm_syntax$ParserFast$lazy(
			function (_v0) {
				return $stil4m$elm_syntax$Elm$Parser$Base$cyclic$moduleNameOrEmpty();
			}),
		_List_Nil);
}
var $stil4m$elm_syntax$Elm$Parser$Base$moduleNameOrEmpty = $stil4m$elm_syntax$Elm$Parser$Base$cyclic$moduleNameOrEmpty();
$stil4m$elm_syntax$Elm$Parser$Base$cyclic$moduleNameOrEmpty = function () {
	return $stil4m$elm_syntax$Elm$Parser$Base$moduleNameOrEmpty;
};
var $stil4m$elm_syntax$Elm$Parser$Base$moduleName = A3(
	$stil4m$elm_syntax$ParserFast$map2WithRange,
	F3(
		function (range, head, tail) {
			return A2(
				$stil4m$elm_syntax$Elm$Syntax$Node$Node,
				range,
				A2($elm$core$List$cons, head, tail));
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeName,
	$stil4m$elm_syntax$Elm$Parser$Base$moduleNameOrEmpty);
var $stil4m$elm_syntax$Elm$Parser$Tokens$typeNameMapWithRange = function (rangeAndNameToRes) {
	return A3($stil4m$elm_syntax$ParserFast$ifFollowedByWhileMapWithRangeWithoutLinebreak, rangeAndNameToRes, $stil4m$elm_syntax$Char$Extra$unicodeIsUpperFast, $stil4m$elm_syntax$Char$Extra$unicodeIsAlphaNumOrUnderscoreFast);
};
var $stil4m$elm_syntax$Elm$Parser$Imports$importDefinition = A6(
	$stil4m$elm_syntax$ParserFast$map5WithStartLocation,
	F6(
		function (start, commentsAfterImport, mod, commentsAfterModuleName, maybeModuleAlias, maybeExposingList) {
			var commentsBeforeAlias = A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterModuleName, commentsAfterImport);
			if (maybeModuleAlias.$ === 1) {
				if (maybeExposingList.$ === 1) {
					var _v2 = mod;
					var modRange = _v2.a;
					return {
						ao: commentsBeforeAlias,
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: modRange.w, z: start},
							{L: $elm$core$Maybe$Nothing, av: $elm$core$Maybe$Nothing, H: mod})
					};
				} else {
					var exposingListValue = maybeExposingList.a;
					var _v3 = exposingListValue.a;
					var exposingRange = _v3.a;
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, exposingListValue.ao, commentsBeforeAlias),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: exposingRange.w, z: start},
							{
								L: $elm$core$Maybe$Just(exposingListValue.a),
								av: $elm$core$Maybe$Nothing,
								H: mod
							})
					};
				}
			} else {
				var moduleAliasResult = maybeModuleAlias.a;
				if (maybeExposingList.$ === 1) {
					var _v5 = moduleAliasResult.a;
					var aliasRange = _v5.a;
					return {
						ao: A2($stil4m$elm_syntax$Rope$prependTo, moduleAliasResult.ao, commentsBeforeAlias),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: aliasRange.w, z: start},
							{
								L: $elm$core$Maybe$Nothing,
								av: $elm$core$Maybe$Just(moduleAliasResult.a),
								H: mod
							})
					};
				} else {
					var exposingListValue = maybeExposingList.a;
					var _v6 = exposingListValue.a;
					var exposingRange = _v6.a;
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							exposingListValue.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, moduleAliasResult.ao, commentsBeforeAlias)),
						a: A2(
							$stil4m$elm_syntax$Elm$Syntax$Node$Node,
							{w: exposingRange.w, z: start},
							{
								L: $elm$core$Maybe$Just(exposingListValue.a),
								av: $elm$core$Maybe$Just(moduleAliasResult.a),
								H: mod
							})
					};
				}
			}
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'import', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Base$moduleName,
	$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
	A5(
		$stil4m$elm_syntax$ParserFast$map3OrSucceed,
		F3(
			function (commentsBefore, moduleAliasNode, commentsAfter) {
				return $elm$core$Maybe$Just(
					{
						ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, commentsBefore),
						a: moduleAliasNode
					});
			}),
		A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'as', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
		$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameMapWithRange(
			F2(
				function (range, moduleAlias) {
					return A2(
						$stil4m$elm_syntax$Elm$Syntax$Node$Node,
						range,
						_List_fromArray(
							[moduleAlias]));
				})),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$elm$core$Maybe$Nothing),
	A4(
		$stil4m$elm_syntax$ParserFast$map2OrSucceed,
		F2(
			function (exposingResult, commentsAfter) {
				return $elm$core$Maybe$Just(
					{
						ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfter, exposingResult.ao),
						a: exposingResult.a
					});
			}),
		$stil4m$elm_syntax$Elm$Parser$Expose$exposeDefinition,
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$elm$core$Maybe$Nothing));
var $stil4m$elm_syntax$Elm$Parser$Layout$endsTopIndented = function (parser) {
	return A3(
		$stil4m$elm_syntax$ParserFast$validateEndColumnIndentation,
		F2(
			function (column, indent) {
				return !(column - indent);
			}),
		'must be on top indentation',
		parser);
};
var $stil4m$elm_syntax$Elm$Parser$Layout$layoutStrict = $stil4m$elm_syntax$Elm$Parser$Layout$endsTopIndented($stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout);
var $stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedByComments = function (nextParser) {
	return A3(
		$stil4m$elm_syntax$ParserFast$map2,
		F2(
			function (commentsBefore, afterComments) {
				return A2($stil4m$elm_syntax$Rope$prependTo, afterComments, commentsBefore);
			}),
		$stil4m$elm_syntax$Elm$Parser$Layout$optimisticLayout,
		$stil4m$elm_syntax$Elm$Parser$Layout$onTopIndentationFollowedBy(nextParser));
};
var $stil4m$elm_syntax$Elm$Parser$Modules$effectWhereClause = A5(
	$stil4m$elm_syntax$ParserFast$map4,
	F4(
		function (fnName, commentsAfterFnName, commentsAfterEqual, typeName_) {
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterEqual, commentsAfterFnName),
				a: _Utils_Tuple2(fnName, typeName_)
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Tokens$functionName,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	A2($stil4m$elm_syntax$ParserFast$symbolFollowedBy, '=', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Tokens$typeNameNode);
var $stil4m$elm_syntax$List$Extra$find = F2(
	function (predicate, list) {
		find:
		while (true) {
			if (!list.b) {
				return $elm$core$Maybe$Nothing;
			} else {
				var x = list.a;
				var xs = list.b;
				if (predicate(x)) {
					return $elm$core$Maybe$Just(x);
				} else {
					var $temp$predicate = predicate,
						$temp$list = xs;
					predicate = $temp$predicate;
					list = $temp$list;
					continue find;
				}
			}
		}
	});
var $stil4m$elm_syntax$Elm$Parser$Modules$whereBlock = A2(
	$stil4m$elm_syntax$ParserFast$followedBySymbol,
	'}',
	A2(
		$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
		'{',
		A5(
			$stil4m$elm_syntax$ParserFast$map4,
			F4(
				function (commentsBeforeHead, head, commentsAfterHead, tail) {
					var pairs = A2($elm$core$List$cons, head.a, tail.a);
					return {
						ao: A2(
							$stil4m$elm_syntax$Rope$prependTo,
							tail.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterHead,
								A2($stil4m$elm_syntax$Rope$prependTo, head.ao, commentsBeforeHead))),
						a: {
							an: A2(
								$elm$core$Maybe$map,
								$elm$core$Tuple$second,
								A2(
									$stil4m$elm_syntax$List$Extra$find,
									function (_v0) {
										var fnName = _v0.a;
										return fnName === 'command';
									},
									pairs)),
							az: A2(
								$elm$core$Maybe$map,
								$elm$core$Tuple$second,
								A2(
									$stil4m$elm_syntax$List$Extra$find,
									function (_v1) {
										var fnName = _v1.a;
										return fnName === 'subscription';
									},
									pairs))
						}
					};
				}),
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$Elm$Parser$Modules$effectWhereClause,
			$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
			$stil4m$elm_syntax$ParserWithComments$many(
				A2(
					$stil4m$elm_syntax$ParserFast$symbolFollowedBy,
					',',
					$stil4m$elm_syntax$Elm$Parser$Layout$maybeAroundBothSides($stil4m$elm_syntax$Elm$Parser$Modules$effectWhereClause))))));
var $stil4m$elm_syntax$Elm$Parser$Modules$effectWhereClauses = A3(
	$stil4m$elm_syntax$ParserFast$map2,
	F2(
		function (commentsBefore, whereResult) {
			return {
				ao: A2($stil4m$elm_syntax$Rope$prependTo, whereResult.ao, commentsBefore),
				a: whereResult.a
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'where', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Modules$whereBlock);
var $stil4m$elm_syntax$ParserFast$map7WithRange = F8(
	function (func, _v0, _v1, _v2, _v3, _v4, _v5, _v6) {
		var parseA = _v0;
		var parseB = _v1;
		var parseC = _v2;
		var parseD = _v3;
		var parseE = _v4;
		var parseF = _v5;
		var parseG = _v6;
		return function (s0) {
			var _v7 = parseA(s0);
			if (_v7.$ === 1) {
				var committed = _v7.a;
				var x = _v7.b;
				return A2($stil4m$elm_syntax$ParserFast$Bad, committed, x);
			} else {
				var a = _v7.a;
				var s1 = _v7.b;
				var _v8 = parseB(s1);
				if (_v8.$ === 1) {
					var x = _v8.b;
					return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
				} else {
					var b = _v8.a;
					var s2 = _v8.b;
					var _v9 = parseC(s2);
					if (_v9.$ === 1) {
						var x = _v9.b;
						return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
					} else {
						var c = _v9.a;
						var s3 = _v9.b;
						var _v10 = parseD(s3);
						if (_v10.$ === 1) {
							var x = _v10.b;
							return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
						} else {
							var d = _v10.a;
							var s4 = _v10.b;
							var _v11 = parseE(s4);
							if (_v11.$ === 1) {
								var x = _v11.b;
								return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
							} else {
								var e = _v11.a;
								var s5 = _v11.b;
								var _v12 = parseF(s5);
								if (_v12.$ === 1) {
									var x = _v12.b;
									return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
								} else {
									var f = _v12.a;
									var s6 = _v12.b;
									var _v13 = parseG(s6);
									if (_v13.$ === 1) {
										var x = _v13.b;
										return A2($stil4m$elm_syntax$ParserFast$Bad, true, x);
									} else {
										var g = _v13.a;
										var s7 = _v13.b;
										return A2(
											$stil4m$elm_syntax$ParserFast$Good,
											A8(
												func,
												{
													w: {p: s7.S, t: s7.t},
													z: {p: s0.S, t: s0.t}
												},
												a,
												b,
												c,
												d,
												e,
												f,
												g),
											s7);
									}
								}
							}
						}
					}
				}
			}
		};
	});
var $stil4m$elm_syntax$Elm$Parser$Modules$effectModuleDefinition = A8(
	$stil4m$elm_syntax$ParserFast$map7WithRange,
	F8(
		function (range, commentsAfterEffect, commentsAfterModule, name, commentsAfterName, whereClauses, commentsAfterWhereClauses, exp) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					exp.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterWhereClauses,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							whereClauses.ao,
							A2(
								$stil4m$elm_syntax$Rope$prependTo,
								commentsAfterName,
								A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterModule, commentsAfterEffect))))),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Module$EffectModule(
						{an: whereClauses.a.an, L: exp.a, H: name, az: whereClauses.a.az}))
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'effect', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'module', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Base$moduleName,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Modules$effectWhereClauses,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Expose$exposeDefinition);
var $stil4m$elm_syntax$Elm$Parser$Modules$normalModuleDefinition = A5(
	$stil4m$elm_syntax$ParserFast$map4WithRange,
	F5(
		function (range, commentsAfterModule, moduleName, commentsAfterModuleName, exposingList) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					exposingList.ao,
					A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterModuleName, commentsAfterModule)),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Module$NormalModule(
						{L: exposingList.a, H: moduleName}))
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'module', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Base$moduleName,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Expose$exposeDefinition);
var $stil4m$elm_syntax$Elm$Parser$Modules$portModuleDefinition = A6(
	$stil4m$elm_syntax$ParserFast$map5WithRange,
	F6(
		function (range, commentsAfterPort, commentsAfterModule, moduleName, commentsAfterModuleName, exposingList) {
			return {
				ao: A2(
					$stil4m$elm_syntax$Rope$prependTo,
					exposingList.ao,
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						commentsAfterModuleName,
						A2($stil4m$elm_syntax$Rope$prependTo, commentsAfterModule, commentsAfterPort))),
				a: A2(
					$stil4m$elm_syntax$Elm$Syntax$Node$Node,
					range,
					$stil4m$elm_syntax$Elm$Syntax$Module$PortModule(
						{L: exposingList.a, H: moduleName}))
			};
		}),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'port', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	A2($stil4m$elm_syntax$ParserFast$keywordFollowedBy, 'module', $stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout),
	$stil4m$elm_syntax$Elm$Parser$Base$moduleName,
	$stil4m$elm_syntax$Elm$Parser$Layout$maybeLayout,
	$stil4m$elm_syntax$Elm$Parser$Expose$exposeDefinition);
var $stil4m$elm_syntax$Elm$Parser$Modules$moduleDefinition = A3($stil4m$elm_syntax$ParserFast$oneOf3, $stil4m$elm_syntax$Elm$Parser$Modules$normalModuleDefinition, $stil4m$elm_syntax$Elm$Parser$Modules$portModuleDefinition, $stil4m$elm_syntax$Elm$Parser$Modules$effectModuleDefinition);
var $stil4m$elm_syntax$Elm$Parser$Comments$moduleDocumentation = $stil4m$elm_syntax$Elm$Parser$Comments$declarationDocumentation;
var $stil4m$elm_syntax$Rope$ropeLikelyFilledToListInto = F2(
	function (initialAcc, ropeLikelyFilled) {
		ropeLikelyFilledToListInto:
		while (true) {
			if (!ropeLikelyFilled.$) {
				var onlyElement = ropeLikelyFilled.a;
				return A2($elm$core$List$cons, onlyElement, initialAcc);
			} else {
				var left = ropeLikelyFilled.a;
				var right = ropeLikelyFilled.b;
				var $temp$initialAcc = A2($stil4m$elm_syntax$Rope$ropeLikelyFilledToListInto, initialAcc, right),
					$temp$ropeLikelyFilled = left;
				initialAcc = $temp$initialAcc;
				ropeLikelyFilled = $temp$ropeLikelyFilled;
				continue ropeLikelyFilledToListInto;
			}
		}
	});
var $stil4m$elm_syntax$Rope$toList = function (rope) {
	if (rope.$ === 1) {
		return _List_Nil;
	} else {
		var ropeLikelyFilled = rope.a;
		return A2($stil4m$elm_syntax$Rope$ropeLikelyFilledToListInto, _List_Nil, ropeLikelyFilled);
	}
};
var $stil4m$elm_syntax$Elm$Parser$File$file = A5(
	$stil4m$elm_syntax$ParserFast$map4,
	F4(
		function (moduleDefinition, moduleComments, imports, declarations) {
			return {
				ao: $stil4m$elm_syntax$Rope$toList(
					A2(
						$stil4m$elm_syntax$Rope$prependTo,
						declarations.ao,
						A2(
							$stil4m$elm_syntax$Rope$prependTo,
							imports.ao,
							A2($stil4m$elm_syntax$Rope$prependTo, moduleComments, moduleDefinition.ao)))),
				T: declarations.a,
				as: imports.a,
				aw: moduleDefinition.a
			};
		}),
	$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedByWithComments($stil4m$elm_syntax$Elm$Parser$Modules$moduleDefinition),
	$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrictFollowedByComments(
		A4(
			$stil4m$elm_syntax$ParserFast$map2OrSucceed,
			F2(
				function (moduleDocumentation, commentsAfter) {
					return A2(
						$stil4m$elm_syntax$Rope$filledPrependTo,
						commentsAfter,
						$stil4m$elm_syntax$Rope$one(moduleDocumentation));
				}),
			$stil4m$elm_syntax$Elm$Parser$Comments$moduleDocumentation,
			$stil4m$elm_syntax$Elm$Parser$Layout$layoutStrict,
			$stil4m$elm_syntax$Rope$empty)),
	$stil4m$elm_syntax$ParserWithComments$many($stil4m$elm_syntax$Elm$Parser$Imports$importDefinition),
	$stil4m$elm_syntax$Elm$Parser$File$fileDeclarations);
var $elm$parser$Parser$ExpectingEnd = {$: 10};
var $elm$parser$Parser$ExpectingKeyword = function (a) {
	return {$: 9, a: a};
};
var $elm$parser$Parser$ExpectingNumber = {$: 6};
var $elm$parser$Parser$ExpectingSymbol = function (a) {
	return {$: 8, a: a};
};
var $elm$parser$Parser$Problem = function (a) {
	return {$: 12, a: a};
};
var $elm$parser$Parser$UnexpectedChar = {$: 11};
var $stil4m$elm_syntax$ParserFast$ropeFilledToList = F2(
	function (problemToConvert, soFar) {
		switch (problemToConvert.$) {
			case 7:
				var firstTry = problemToConvert.a;
				var secondTry = problemToConvert.b;
				var thirdTryUp = problemToConvert.c;
				return A2(
					$stil4m$elm_syntax$ParserFast$ropeFilledToList,
					firstTry,
					A2(
						$stil4m$elm_syntax$ParserFast$ropeFilledToList,
						secondTry,
						A3($elm$core$List$foldr, $stil4m$elm_syntax$ParserFast$ropeFilledToList, soFar, thirdTryUp)));
			case 0:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				return A2(
					$elm$core$List$cons,
					{S: col, ad: $elm$parser$Parser$ExpectingNumber, t: row},
					soFar);
			case 1:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				var symbolString = problemToConvert.c;
				return A2(
					$elm$core$List$cons,
					{
						S: col,
						ad: $elm$parser$Parser$ExpectingSymbol(symbolString),
						t: row
					},
					soFar);
			case 2:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				return A2(
					$elm$core$List$cons,
					{
						S: col,
						ad: $elm$parser$Parser$Problem('expecting any char'),
						t: row
					},
					soFar);
			case 3:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				var keywordString = problemToConvert.c;
				return A2(
					$elm$core$List$cons,
					{
						S: col,
						ad: $elm$parser$Parser$ExpectingKeyword(keywordString),
						t: row
					},
					soFar);
			case 4:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				return A2(
					$elm$core$List$cons,
					{S: col, ad: $elm$parser$Parser$UnexpectedChar, t: row},
					soFar);
			case 5:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				return A2(
					$elm$core$List$cons,
					{
						S: col,
						ad: $elm$parser$Parser$Problem('expected string to pass validation'),
						t: row
					},
					soFar);
			default:
				var row = problemToConvert.a;
				var col = problemToConvert.b;
				var customMessage = problemToConvert.c;
				return A2(
					$elm$core$List$cons,
					{
						S: col,
						ad: $elm$parser$Parser$Problem(customMessage),
						t: row
					},
					soFar);
		}
	});
var $stil4m$elm_syntax$ParserFast$run = F2(
	function (_v0, src) {
		var parse = _v0;
		var _v1 = parse(
			{S: 1, g: 1, c: 0, t: 1, b: src});
		if (!_v1.$) {
			var value = _v1.a;
			var finalState = _v1.b;
			return (!(finalState.c - $elm$core$String$length(finalState.b))) ? $elm$core$Result$Ok(value) : $elm$core$Result$Err(
				_List_fromArray(
					[
						{S: finalState.S, ad: $elm$parser$Parser$ExpectingEnd, t: finalState.t}
					]));
		} else {
			var deadEnds = _v1.b;
			return $elm$core$Result$Err(
				A2($stil4m$elm_syntax$ParserFast$ropeFilledToList, deadEnds, _List_Nil));
		}
	});
var $stil4m$elm_syntax$Elm$Parser$parseToFile = function (input) {
	return A2($stil4m$elm_syntax$ParserFast$run, $stil4m$elm_syntax$Elm$Parser$File$file, input);
};
var $stil4m$elm_syntax$Elm$Parser$parse = function (input) {
	return A2(
		$elm$core$Result$map,
		$stil4m$elm_syntax$Elm$Internal$RawFile$fromFile,
		$stil4m$elm_syntax$Elm$Parser$parseToFile(input));
};
var $stil4m$elm_syntax$Elm$Processing$process = F2(
	function (_v0, _v1) {
		var file = _v1;
		return file;
	});
var $author$project$ParseMain$parseSource = function (source) {
	var _v0 = $stil4m$elm_syntax$Elm$Parser$parse(source);
	if (!_v0.$) {
		var ast = _v0.a;
		return $elm$core$Result$Ok(
			A2($stil4m$elm_syntax$Elm$Processing$process, $author$project$ParseMain$elmProcessContext, ast));
	} else {
		return $elm$core$Result$Err(0);
	}
};
var $author$project$ParseMain$update = function (_v0) {
	var source = _v0;
	var json = function () {
		var _v1 = $author$project$ParseMain$parseSource(source);
		if (!_v1.$) {
			var ast = _v1.a;
			return $author$project$Elm$Review$AstCodec$encode(ast);
		} else {
			return $elm$json$Json$Encode$null;
		}
	}();
	return $author$project$ParseMain$parseResult(json);
};
var $elm$core$Platform$worker = _Platform_worker;
var $author$project$ParseMain$main = $elm$core$Platform$worker(
	{
		at: $elm$core$Basics$always(
			_Utils_Tuple2(0, $elm$core$Platform$Cmd$none)),
		aA: $elm$core$Basics$always($author$project$ParseMain$subscriptions),
		aB: F2(
			function (msg, _v0) {
				return _Utils_Tuple2(
					0,
					$author$project$ParseMain$update(msg));
			})
	});
_Platform_export({'ParseMain':{'init':$author$project$ParseMain$main(
	$elm$json$Json$Decode$succeed(0))(0)}});}(this));